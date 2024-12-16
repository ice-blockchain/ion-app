// SPDX-License-Identifier: ice License 1.0

import 'dart:async';
import 'dart:convert';

import 'package:ion/app/features/feed/data/models/entities/article_data.c.dart';
import 'package:ion/app/features/feed/views/components/text_editor/components/custom_blocks/text_editor_single_image_block/text_editor_single_image_block.dart';
import 'package:ion/app/features/gallery/providers/providers.dart';
import 'package:ion/app/features/nostr/model/file_alt.dart';
import 'package:ion/app/features/nostr/model/file_metadata.c.dart';
import 'package:ion/app/features/nostr/providers/nostr_notifier.c.dart';
import 'package:ion/app/features/nostr/providers/nostr_upload_notifier.c.dart';
import 'package:ion/app/services/compressor/compress_service.c.dart';
import 'package:ion/app/services/logger/logger.dart';
import 'package:ion/app/services/media_service/media_service.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'create_article_notifier.c.g.dart';

@Riverpod(dependencies: [])
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

    Logger.log('CreateArticleNotifier: create');

    state = await AsyncValue.guard(() async {
      String? imageUrl;
      final files = <FileMetadata>[];
      final uploadedUrls = <String, String>{};
      Logger.log('files : $files');
      Logger.log('uploadedUrls : $uploadedUrls');

      if (mediaIds != null && mediaIds.isNotEmpty) {
        Logger.log('mediaIds : $mediaIds');
        await Future.wait(
          mediaIds.map((id) async {
            final (:fileMetadata, :mediaAttachment) = await _uploadImage(id);
            uploadedUrls[id] = mediaAttachment.url;
            files.add(fileMetadata);
          }),
        );
        Logger.log('_replaceImagePathsWithUrls BEFORE');
        content = _replaceImagePathsWithUrls(content, uploadedUrls);
        Logger.log('_replaceImagePathsWithUrls AFTER');
      }

      if (imageId != null) {
        Logger.log('imageId != null');
        final uploadResult = await _uploadImage(imageId);
        Logger.log('imageId != null AFTER UPLOAD');
        imageUrl = uploadResult.mediaAttachment.url;
      }

      final articleData = ArticleData(
        title: title,
        summary: summary,
        image: imageUrl,
        content: content,
        media: {},
        publishedAt: publishedAt ?? DateTime.now(),
      );

      Logger.log('Article data: $articleData');
      await ref.read(nostrNotifierProvider.notifier).sendEntitiesData([...files, articleData]);
    });
  }

  String _replaceImagePathsWithUrls(String content, Map<String, String> uploadedUrls) {
    try {
      Logger.log('Content BEFORE parsing: $content');

      // Ensure the content is a valid JSON string
      final dynamic parsedContent = jsonDecode(content);

      if (parsedContent is! List<dynamic>) {
        throw const FormatException('Content is not a valid list of operations.');
      }

      // Iterate over each operation
      for (final operation in parsedContent) {
        if (operation is Map<String, dynamic> &&
            operation.containsKey('insert') &&
            operation['insert'] is Map<String, dynamic>) {
          final insertData = operation['insert'] as Map<String, dynamic>;

          // Look for the specific key and replace the local path with uploaded URL
          if (insertData.containsKey(textEditorSingleImageKey)) {
            final localPath = insertData[textEditorSingleImageKey] as String?;
            Logger.log('Found localPath: $localPath');

            if (localPath != null && uploadedUrls.containsKey(localPath)) {
              Logger.log('Replacing $localPath with ${uploadedUrls[localPath]}');
              insertData[textEditorSingleImageKey] = uploadedUrls[localPath];
            } else if (localPath != null) {
              Logger.log('No uploaded URL found for $localPath');
            }
          }
        }
      }

      // Convert the modified operations back to JSON string
      final modifiedContent = jsonEncode(parsedContent);
      Logger.log('Content AFTER replacement: $modifiedContent');
      return modifiedContent;
    } catch (e, stackTrace) {
      Logger.log('Error in _replaceImagePathsWithUrls: $e');
      Logger.log('Stack trace: $stackTrace');

      // Return the original content if parsing fails
      return content;
    }
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
