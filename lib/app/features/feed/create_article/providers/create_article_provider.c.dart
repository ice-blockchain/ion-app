// SPDX-License-Identifier: ice License 1.0

import 'dart:async';
import 'dart:convert';

import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/feed/data/models/entities/article_data.c.dart';
import 'package:ion/app/features/gallery/providers/providers.dart';
import 'package:ion/app/features/nostr/model/file_alt.dart';
import 'package:ion/app/features/nostr/model/file_metadata.c.dart';
import 'package:ion/app/features/nostr/model/media_attachment.dart';
import 'package:ion/app/features/nostr/providers/nostr_notifier.c.dart';
import 'package:ion/app/features/nostr/providers/nostr_upload_notifier.c.dart';
import 'package:ion/app/services/compressor/compress_service.c.dart';
import 'package:ion/app/services/media_service/media_service.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'create_article_provider.c.g.dart';

@riverpod
class CreateArticle extends _$CreateArticle {
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
      final files = <FileMetadata>[];
      final mediaAttachments = <MediaAttachment>[];

      final mainImageFuture = _getUploadImage(imageId, files);
      final contentFuture = _prepareContent(content, mediaIds, files, mediaAttachments);

      final (imageUrl, updatedContent) = await (mainImageFuture, contentFuture).wait;

      final relatedHashtags = ArticleData.extractHashtagsFromMarkdown(updatedContent);

      final articleData = ArticleData(
        title: title,
        summary: summary,
        image: imageUrl,
        content: updatedContent,
        media: {for (final attachment in mediaAttachments) attachment.url: attachment},
        relatedHashtags: relatedHashtags,
        publishedAt: publishedAt ?? DateTime.now(),
      );

      await ref.read(nostrNotifierProvider.notifier).sendEntitiesData([...files, articleData]);
    });
  }

  Future<String?> _getUploadImage(String? imageId, List<FileMetadata> files) async {
    if (imageId == null) return null;

    final uploadResult = await _uploadImage(imageId);
    files.add(uploadResult.fileMetadata);
    return uploadResult.mediaAttachment.url;
  }

  Future<String> _prepareContent(
    String content,
    List<String>? mediaIds,
    List<FileMetadata> files,
    List<MediaAttachment> mediaAttachments,
  ) async {
    final uploadedUrls = <String, String>{};

    var updatedContent = content;

    if (mediaIds != null && mediaIds.isNotEmpty) {
      await Future.wait(
        mediaIds.map((id) async {
          final (:fileMetadata, :mediaAttachment) = await _uploadImage(id);
          uploadedUrls[id] = mediaAttachment.url;
          files.add(fileMetadata);
          mediaAttachments.add(mediaAttachment);
        }),
      );
      updatedContent = _replaceImagePathsWithUrls(updatedContent, uploadedUrls);
    }

    return updatedContent;
  }

  String _replaceImagePathsWithUrls(String content, Map<String, String> uploadedUrls) {
    final parsedContent = jsonDecode(content) as List<dynamic>;

    for (final operation in parsedContent) {
      if (operation case {'insert': {textEditorSingleImageKey: final String? localPath}}) {
        if (localPath != null && uploadedUrls.containsKey(localPath)) {
          final insertData = operation['insert'] as Map<String, dynamic>;
          insertData[textEditorSingleImageKey] = uploadedUrls[localPath];
        }
      }
    }

    return jsonEncode(parsedContent);
  }

  Future<UploadResult> _uploadImage(String imageId) async {
    final assetEntity = await ref.read(assetEntityProvider(imageId).future);
    if (assetEntity == null) throw AssetEntityFileNotFoundException();

    final file = await assetEntity.file;
    if (file == null) throw AssetEntityFileNotFoundException();

    const maxDimension = 1024;
    final compressedImage = await ref.read(compressServiceProvider).compressImage(
          MediaFile(path: file.path),
          width: assetEntity.width > assetEntity.height ? maxDimension : null,
          height: assetEntity.height > assetEntity.width ? maxDimension : null,
          quality: 70,
        );

    return ref.read(nostrUploadNotifierProvider.notifier).upload(
          compressedImage,
          alt: FileAlt.article,
        );
  }
}
