// SPDX-License-Identifier: ice License 1.0

import 'dart:async';
import 'dart:convert';

import 'package:ion/app/features/feed/data/models/entities/article_data.c.dart';
import 'package:ion/app/features/feed/data/models/who_can_reply_settings_option.dart';
import 'package:ion/app/features/ion_connect/model/file_alt.dart';
import 'package:ion/app/features/ion_connect/model/file_metadata.c.dart';
import 'package:ion/app/features/ion_connect/model/media_attachment.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_notifier.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_upload_notifier.c.dart';
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
    required WhoCanReplySettingsOption whoCanReply,
    String? title,
    String? summary,
    String? imageId,
    DateTime? publishedAt,
    List<String>? mediaIds,
    String? imageColor,
  }) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      final files = <FileMetadata>[];
      final mediaAttachments = <MediaAttachment>[];

      final mainImageFuture = _getUploadImage(imageId, files, mediaAttachments);
      final contentFuture = _prepareContent(content, mediaIds, files, mediaAttachments);

      final (imageUrl, updatedContent) = await (mainImageFuture, contentFuture).wait;

      final relatedHashtags = ArticleData.extractTagsFromMarkdown(updatedContent);

      final articleData = ArticleData.fromData(
        title: title,
        summary: summary,
        image: imageUrl,
        content: updatedContent,
        media: {
          for (final attachment in mediaAttachments) attachment.url: attachment,
        },
        relatedHashtags: relatedHashtags,
        publishedAt: publishedAt ?? DateTime.now(),
        whoCanReplySettings: {whoCanReply},
        imageColor: imageColor,
      );

      await ref.read(ionConnectNotifierProvider.notifier).sendEntitiesData([...files, articleData]);
    });
  }

  Future<String?> _getUploadImage(
    String? imageId,
    List<FileMetadata> files,
    List<MediaAttachment> mediaAttachments,
  ) async {
    if (imageId == null) return null;

    final uploadResult = await _uploadImage(imageId, extractColor: true);
    files.add(uploadResult.fileMetadata);
    mediaAttachments.add(uploadResult.mediaAttachment);
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

  String _replaceImagePathsWithUrls(
    String content,
    Map<String, String> uploadedUrls,
  ) {
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

  Future<UploadResult> _uploadImage(String imageId, {bool extractColor = false}) async {
    final compressService = ref.read(compressServiceProvider);
    final dimension = await compressService.getImageDimension(path: imageId);

    final result = await ref.read(ionConnectUploadNotifierProvider.notifier).upload(
          MediaFile(
            path: imageId,
            width: dimension.width,
            height: dimension.height,
          ),
          alt: FileAlt.article,
        );
    return result;
  }
}
