// SPDX-License-Identifier: ice License 1.0

import 'dart:async';
import 'dart:convert';

import 'package:flutter_quill/quill_delta.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/text_editor/components/custom_blocks/text_editor_single_image_block/text_editor_single_image_block.dart';
import 'package:ion/app/components/text_editor/utils/extract_tags.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/core/providers/env_provider.c.dart';
import 'package:ion/app/features/feed/create_article/providers/draft_article_provider.c.dart';
import 'package:ion/app/features/feed/data/models/article_topic.dart';
import 'package:ion/app/features/feed/data/models/entities/article_data.c.dart';
import 'package:ion/app/features/feed/data/models/who_can_reply_settings_option.dart';
import 'package:ion/app/features/gallery/providers/gallery_provider.c.dart';
import 'package:ion/app/features/ion_connect/model/color_label.c.dart';
import 'package:ion/app/features/ion_connect/model/entity_data_with_settings.dart';
import 'package:ion/app/features/ion_connect/model/entity_editing_ended_at.c.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';
import 'package:ion/app/features/ion_connect/model/event_serializable.dart';
import 'package:ion/app/features/ion_connect/model/file_alt.dart';
import 'package:ion/app/features/ion_connect/model/file_metadata.c.dart';
import 'package:ion/app/features/ion_connect/model/ion_connect_entity.dart';
import 'package:ion/app/features/ion_connect/model/media_attachment.dart';
import 'package:ion/app/features/ion_connect/model/related_hashtag.c.dart';
import 'package:ion/app/features/ion_connect/model/rich_text.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_delete_file_notifier.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_entity_provider.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_notifier.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_upload_notifier.c.dart';
import 'package:ion/app/services/compressors/image_compressor.c.dart';
import 'package:ion/app/services/markdown/quill.dart';
import 'package:ion/app/services/media_service/media_service.c.dart';
import 'package:ion/app/utils/image_path.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'create_article_provider.c.g.dart';

final _createArticleNotifierStreamController = StreamController<IonConnectEntity>.broadcast();

@riverpod
Raw<Stream<IonConnectEntity>> createArticleNotifierStream(Ref ref) {
  return _createArticleNotifierStreamController.stream;
}

enum CreateArticleOption {
  plain,
  softDelete,
  modify;
}

@riverpod
class CreateArticle extends _$CreateArticle {
  @override
  FutureOr<void> build(CreateArticleOption createOption) {}

  Future<void> create({
    required Delta content,
    required WhoCanReplySettingsOption whoCanReply,
    required List<ArticleTopic> topics,
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
      final contentFuture = _prepareContent(
        content: content,
        mediaIds: mediaIds,
        files: files,
        mediaAttachments: mediaAttachments,
      );

      final (imageUrl, updatedContent) = await (mainImageFuture, contentFuture).wait;

      final richText = RichText(
        protocol: 'quill_delta',
        content: jsonEncode(updatedContent.toJson()),
      );

      final relatedHashtags = [
        ...topics.map((topic) => RelatedHashtag(value: topic.toShortString())),
        ...extractTags(updatedContent).map((tag) => RelatedHashtag(value: tag)),
      ];

      final editingEndedAt = EntityEditingEndedAt.build(
        ref.read(envProvider.notifier).get<int>(EnvVariable.EDIT_POST_ALLOWED_MINUTES),
      );

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
        settings: EntityDataWithSettings.build(whoCanReply: whoCanReply),
        imageColor: imageColor,
        richText: richText,
        editingEndedAt: editingEndedAt,
      );

      final entities = await _sendArticleEntities([...files, articleData]);
      entities?.whereType<ArticleEntity>().forEach(_createArticleNotifierStreamController.add);

      ref.read(draftArticleProvider.notifier).clear();
    });
  }

  Future<void> softDelete({
    required EventReference eventReference,
  }) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      final entity =
          await ref.read(ionConnectEntityProvider(eventReference: eventReference).future);
      if (entity is! ArticleEntity) {
        throw UnsupportedEventReference(eventReference);
      }

      final articleData = entity.data.copyWith(
        title: null,
        summary: null,
        image: null,
        content: '',
        relatedHashtags: [],
        media: {},
        colorLabel: null,
        settings: null,
        richText: null,
        editingEndedAt: null,
      );

      await _sendArticleEntities([articleData]);
    });
  }

  Future<void> modify({
    required EventReference eventReference,
    required Delta content,
    required WhoCanReplySettingsOption whoCanReply,
    required List<ArticleTopic> topics,
    String? title,
    String? summary,
    String? coverImagePath,
    String? originalImageUrl,
    Map<String, MediaAttachment> mediaAttachments = const {},
    String? imageColor,
  }) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      final modifiedEntity =
          await ref.read(ionConnectEntityProvider(eventReference: eventReference).future);
      if (modifiedEntity is! ArticleEntity) {
        throw UnsupportedEventReference(eventReference);
      }

      final files = <FileMetadata>[];
      final updatedMediaAttachments = <MediaAttachment>[];

      final String? imageUrlToUpload;

      if (originalImageUrl != null) {
        imageUrlToUpload = originalImageUrl;
      } else {
        imageUrlToUpload = await _uploadCoverImage(coverImagePath, files, updatedMediaAttachments);
      }

      final updatedContent = await _prepareContent(
        content: content,
        files: files,
        mediaAttachments: updatedMediaAttachments,
      );

      final contentString = jsonEncode(updatedContent.toJson());

      final richText = RichText(
        protocol: 'quill_delta',
        content: contentString,
      );

      final relatedHashtags = [
        ...topics.map((topic) => RelatedHashtag(value: topic.toShortString())),
        ...extractTags(updatedContent).map((tag) => RelatedHashtag(value: tag)),
      ];

      final modifiedMedia = Map<String, MediaAttachment>.from(mediaAttachments);
      for (final attachment in updatedMediaAttachments) {
        modifiedMedia[attachment.url] = attachment;
      }

      final unusedMediaFileHashes = <String>[];

      final cleanedMedia = Map<String, MediaAttachment>.from(modifiedEntity.data.media);

      modifiedEntity.data.media.forEach((url, attachment) {
        final urlInContent = contentString.contains(url);
        final urlToCheck = url.replaceAll('url ', '');
        if (!urlInContent && (originalImageUrl != null && urlToCheck != originalImageUrl)) {
          cleanedMedia.remove(url);
          unusedMediaFileHashes.add(attachment.originalFileHash);
        }
      });

      for (final attachment in updatedMediaAttachments) {
        cleanedMedia[attachment.url] = attachment;
      }

      final articleData = modifiedEntity.data.copyWith(
        title: title,
        summary: summary,
        image: imageUrlToUpload,
        content: deltaToMarkdown(updatedContent),
        media: cleanedMedia,
        relatedHashtags: relatedHashtags,
        settings: EntityDataWithSettings.build(whoCanReply: whoCanReply),
        colorLabel: imageColor != null ? ColorLabel(value: imageColor) : null,
        richText: richText,
      );

      if (unusedMediaFileHashes.isNotEmpty) {
        await ref
            .read(ionConnectDeleteFileNotifierProvider.notifier)
            .deleteMultiple(unusedMediaFileHashes);
      }
      await _sendArticleEntities([...files, articleData]);
      ref.read(draftArticleProvider.notifier).clear();
    });
  }

  Future<List<IonConnectEntity>?> _sendArticleEntities(List<EventSerializable> entitiesData) async {
    return ref.read(ionConnectNotifierProvider.notifier).sendEntitiesData(entitiesData);
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

  Future<Delta> _prepareContent({
    required Delta content,
    required List<FileMetadata> files,
    required List<MediaAttachment> mediaAttachments,
    List<String>? mediaIds,
  }) async {
    final uploadedUrls = <String, String>{};

    var updatedContent = content;

    final draftArticle = ref.read(draftArticleProvider);
    final codeBlocks = draftArticle.codeBlocks;

    updatedContent = Delta.fromOperations(
      updatedContent.toList().map((operation) {
        if (operation.isInsert && operation.data is Map<String, dynamic>) {
          final mapData = operation.data! as Map<String, dynamic>;
          if (mapData.containsKey('text-editor-code')) {
            final blockId = mapData['text-editor-code'];
            if (codeBlocks.containsKey(blockId)) {
              return Operation.insert({
                'text-editor-code': codeBlocks[blockId],
              });
            }
          }
        }
        return operation;
      }).toList(),
    );

    if (mediaIds != null && mediaIds.isNotEmpty) {
      await Future.wait(
        mediaIds.map((assetId) async {
          final imagePath = await getOriginalAssetPath(assetId);
          final (:fileMetadata, :mediaAttachment) = await _uploadImage(imagePath);
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
    final imageCompressor = ref.read(imageCompressorProvider);
    final dimension = await imageCompressor.getImageDimension(path: imagePath);
    final file = MediaFile(
      path: imagePath,
      width: dimension.width,
      height: dimension.height,
    );
    final compressedImage = await imageCompressor.compress(file);

    final result = await ref.read(ionConnectUploadNotifierProvider.notifier).upload(
          compressedImage,
          alt: FileAlt.article,
        );
    return result;
  }

  Future<String> getOriginalAssetPath(String assetId) async {
    final assetEntity = await ref.read(assetEntityProvider(assetId).future);

    if (assetEntity == null) {
      throw AssetEntityFileNotFoundException(assetId: assetId);
    }

    final isGif = await isGifAsset(assetEntity);
    if (isGif) {
      final file = await assetEntity.originFile;
      if (file == null) {
        throw AssetEntityFileNotFoundException(assetId: assetId);
      }
      return file.path;
    }

    final defaultPath = await ref.read(assetFilePathProvider(assetId).future);
    if (defaultPath == null || defaultPath.isEmpty) {
      throw AssetEntityFileNotFoundException(assetId: assetId);
    }

    return defaultPath;
  }
}
