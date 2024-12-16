// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:ion/app/features/feed/data/models/entities/article_data.c.dart';
import 'package:ion/app/features/gallery/providers/providers.dart';
import 'package:ion/app/features/nostr/model/file_alt.dart';
import 'package:ion/app/features/nostr/model/file_metadata.c.dart';
import 'package:ion/app/features/nostr/model/media_attachment.dart';
import 'package:ion/app/features/nostr/providers/nostr_notifier.c.dart';
import 'package:ion/app/features/nostr/providers/nostr_upload_notifier.c.dart';
import 'package:ion/app/services/compressor/compress_service.c.dart';
import 'package:ion/app/services/logger/logger.dart';
import 'package:ion/app/services/media_service/media_service.c.dart';
import 'package:ion/app/services/text_parser/text_match.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'create_article_notifier.c.g.dart';

@Riverpod(
  dependencies: [],
)
class CreateArticleNotifier extends _$CreateArticleNotifier {
  @override
  FutureOr<void> build() {}

  Future<void> create({
    required String content,
    String? title,
    String? summary,
    String? imageId,
    DateTime? publishedAt,
    List<String>? mediaIds,
  }) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      String? imageUrl;
      var data = ArticleData.fromRawContent(content.trim());
      final files = <FileMetadata>[];

      if (mediaIds != null) {
        final attachments = <MediaAttachment>[];
        await Future.wait(
          mediaIds.map((id) async {
            final (:fileMetadata, :mediaAttachment) = await _uploadImage(id);
            attachments.add(mediaAttachment);
            files.add(fileMetadata);
          }),
        );
        data = data.copyWith(
          content: [
            ...attachments.map((attachment) => TextMatch('${attachment.url} ')),
            ...data.content,
          ],
          media: {for (final attachment in attachments) attachment.url: attachment},
        );
      }

      if (imageId != null) {
        final uploadResult = await _uploadImage(imageId);
        imageUrl = uploadResult.mediaAttachment.url;
        Logger.log('ARTICLE IMAGE UPLOADED');
      }

      final articleData = ArticleData(
        title: title,
        summary: summary,
        image: imageUrl,
        content: data.content,
        media: data.media,
        publishedAt: publishedAt ?? DateTime.now(),
      );

      await ref.read(nostrNotifierProvider.notifier).sendEntitiesData([
        ...files,
        articleData,
      ]);

      Logger.log('ARTICLE SENT');
    });
  }

  Future<UploadResult> _uploadImage(String imageId) async {
    final assetEntity = await ref.read(assetEntityProvider(imageId).future);
    if (assetEntity == null) {
      throw Exception('Image not found');
    }

    final file = await assetEntity.file;
    if (file == null) {
      throw Exception('Failed to retrieve image file');
    }

    const maxDimension = 1024;
    final compressedImage = await ref.read(compressServiceProvider).compressImage(
          MediaFile(path: file.path),
          width: assetEntity.width > assetEntity.height ? maxDimension : null,
          height: assetEntity.height > assetEntity.width ? maxDimension : null,
          quality: 70,
        );

    return ref
        .read(nostrUploadNotifierProvider.notifier)
        .upload(compressedImage, alt: FileAlt.article);
  }
}
