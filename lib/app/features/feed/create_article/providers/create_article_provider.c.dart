// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:flutter_quill/quill_delta.dart';
import 'package:ion/app/features/feed/data/models/entities/article_data.c.dart';
import 'package:ion/app/features/feed/data/models/who_can_reply_settings_option.dart';
import 'package:ion/app/features/feed/views/components/text_editor/components/custom_blocks/text_editor_single_image_block/text_editor_single_image_block.dart';
import 'package:ion/app/features/feed/views/components/text_editor/utils/extract_tags.dart';
import 'package:ion/app/features/gallery/providers/gallery_provider.c.dart';
import 'package:ion/app/features/ion_connect/model/entity_settings_data.dart';
import 'package:ion/app/features/ion_connect/model/file_alt.dart';
import 'package:ion/app/features/ion_connect/model/file_metadata.c.dart';
import 'package:ion/app/features/ion_connect/model/media_attachment.dart';
import 'package:ion/app/features/ion_connect/model/related_hashtag.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_notifier.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_upload_notifier.c.dart';
import 'package:ion/app/services/compressor/compress_service.c.dart';
import 'package:ion/app/services/markdown/quill.dart';
import 'package:ion/app/services/media_service/media_service.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'create_article_provider.c.g.dart';

@riverpod
class CreateArticle extends _$CreateArticle {
  @override
  FutureOr<void> build() {}

  Future<void> create({
    required Delta content,
    required WhoCanReplySettingsOption whoCanReply,
    String? title,
    String? summary,
    String? coverImagePath,
    DateTime? publishedAt,
    List<String>? mediaIds,
    String? imageColor,
  }) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      final files = <FileMetadata>[];
      final mediaAttachments = <MediaAttachment>[];

      final mainImageFuture = _uploadCoverImage(coverImagePath, files, mediaAttachments);
      final contentFuture = _prepareContent(content, mediaIds, files, mediaAttachments);

      final (imageUrl, updatedContent) = await (mainImageFuture, contentFuture).wait;

      final relatedHashtags =
          extractTags(updatedContent).map((tag) => RelatedHashtag(value: tag)).toList();

      final articleData = ArticleData.fromData(
        title: title,
        summary: summary,
        image: imageUrl,
        content: deltaToMarkdown(updatedContent),
        media: {
          for (final attachment in mediaAttachments) attachment.url: attachment,
        },
        relatedHashtags: relatedHashtags,
        publishedAt: publishedAt,
        settings: EntitySettingsDataMixin.build(whoCanReply: whoCanReply),
        imageColor: imageColor,
      );

      await ref.read(ionConnectNotifierProvider.notifier).sendEntitiesData([...files, articleData]);
    });
  }

  Future<String?> _uploadCoverImage(
    String? imagePath,
    List<FileMetadata> files,
    List<MediaAttachment> mediaAttachments,
  ) async {
    if (imagePath == null) return null;

    final uploadResult = await _uploadImage(imagePath, extractColor: true);
    files.add(uploadResult.fileMetadata);
    mediaAttachments.add(uploadResult.mediaAttachment);
    return uploadResult.mediaAttachment.url;
  }

  Future<Delta> _prepareContent(
    Delta content,
    List<String>? mediaIds,
    List<FileMetadata> files,
    List<MediaAttachment> mediaAttachments,
  ) async {
    final uploadedUrls = <String, String>{};

    var updatedContent = content;

    if (mediaIds != null && mediaIds.isNotEmpty) {
      await Future.wait(
        mediaIds.map((assetId) async {
          final imagePath = await ref.read(assetFilePathProvider(assetId).future);
          final (:fileMetadata, :mediaAttachment) = await _uploadImage(imagePath!);
          uploadedUrls[assetId] = mediaAttachment.url;
          files.add(fileMetadata);
          mediaAttachments.add(mediaAttachment);
        }),
      );
      updatedContent = _replaceImagePathsWithUrls(updatedContent, uploadedUrls);
    }

    return updatedContent;
  }

  Delta _replaceImagePathsWithUrls(
    Delta content,
    Map<String, String> uploadedUrls,
  ) {
    return Delta.fromOperations(
      content.map((operation) {
        final operationData = operation.data;
        if (operation.isInsert &&
            operationData is Map<String, dynamic> &&
            operationData.containsKey(textEditorSingleImageKey) &&
            operationData[textEditorSingleImageKey] != null &&
            uploadedUrls.containsKey(operationData[textEditorSingleImageKey])) {
          return Operation.insert(
            uploadedUrls[operationData[textEditorSingleImageKey]],
            {textEditorSingleImageKey: uploadedUrls[operationData[textEditorSingleImageKey]]},
          );
        }
        return operation;
      }).toList(),
    );
  }

  Future<UploadResult> _uploadImage(String imagePath, {bool extractColor = false}) async {
    final dimension = await ref.read(compressServiceProvider).getImageDimension(path: imagePath);

    final result = await ref.read(ionConnectUploadNotifierProvider.notifier).upload(
          MediaFile(
            path: imagePath,
            width: dimension.width,
            height: dimension.height,
          ),
          alt: FileAlt.article,
        );
    return result;
  }
}
