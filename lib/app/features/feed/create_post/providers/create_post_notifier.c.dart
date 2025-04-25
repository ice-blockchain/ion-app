// SPDX-License-Identifier: ice License 1.0

import 'dart:async';
import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/quill_delta.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/text_editor/components/custom_blocks/text_editor_profile_block/text_editor_profile_block.dart';
import 'package:ion/app/components/text_editor/utils/build_empty_delta.dart';
import 'package:ion/app/components/text_editor/utils/extract_tags.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/core/model/media_type.dart';
import 'package:ion/app/features/core/providers/env_provider.c.dart';
import 'package:ion/app/features/feed/create_post/model/create_post_option.dart';
import 'package:ion/app/features/feed/data/models/entities/article_data.c.dart';
import 'package:ion/app/features/feed/data/models/entities/modifiable_post_data.c.dart';
import 'package:ion/app/features/feed/data/models/entities/post_data.c.dart';
import 'package:ion/app/features/feed/data/models/who_can_reply_settings_option.dart';
import 'package:ion/app/features/feed/providers/counters/replies_count_provider.c.dart';
import 'package:ion/app/features/feed/providers/counters/reposts_count_provider.c.dart';
import 'package:ion/app/features/ion_connect/model/entity_data_with_settings.dart';
import 'package:ion/app/features/ion_connect/model/entity_editing_ended_at.c.dart';
import 'package:ion/app/features/ion_connect/model/entity_expiration.c.dart';
import 'package:ion/app/features/ion_connect/model/entity_published_at.c.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';
import 'package:ion/app/features/ion_connect/model/event_serializable.dart';
import 'package:ion/app/features/ion_connect/model/file_alt.dart';
import 'package:ion/app/features/ion_connect/model/file_metadata.c.dart';
import 'package:ion/app/features/ion_connect/model/ion_connect_entity.dart';
import 'package:ion/app/features/ion_connect/model/media_attachment.dart';
import 'package:ion/app/features/ion_connect/model/quoted_event.c.dart';
import 'package:ion/app/features/ion_connect/model/related_event.c.dart';
import 'package:ion/app/features/ion_connect/model/related_event_marker.dart';
import 'package:ion/app/features/ion_connect/model/related_hashtag.c.dart';
import 'package:ion/app/features/ion_connect/model/related_pubkey.c.dart';
import 'package:ion/app/features/ion_connect/model/replaceable_event_identifier.c.dart';
import 'package:ion/app/features/ion_connect/model/rich_text.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_delete_file_notifier.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_entity_provider.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_notifier.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_upload_notifier.c.dart';
import 'package:ion/app/services/compressors/image_compressor.c.dart';
import 'package:ion/app/services/compressors/video_compressor.c.dart';
import 'package:ion/app/services/logger/logger.dart';
import 'package:ion/app/services/markdown/quill.dart';
import 'package:ion/app/services/media_service/media_service.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'create_post_notifier.c.g.dart';

final _createPostNotifierStreamController = StreamController<IonConnectEntity>.broadcast();

@riverpod
Raw<Stream<IonConnectEntity>> createPostNotifierStream(Ref ref) {
  return _createPostNotifierStreamController.stream;
}

@riverpod
class CreatePostNotifier extends _$CreatePostNotifier {
  @override
  FutureOr<void> build(CreatePostOption createOption) {}

  Future<void> create({
    Delta? content,
    WhoCanReplySettingsOption whoCanReply = WhoCanReplySettingsOption.everyone,
    EventReference? parentEvent,
    EventReference? quotedEvent,
    List<MediaFile>? mediaFiles,
    String? communityId,
  }) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      final postContent = content ?? buildEmptyDelta();
      final parentEntity = parentEvent != null ? await _getParentEntity(parentEvent) : null;
      final (:files, :media) = await _uploadMediaFiles(mediaFiles: mediaFiles);
      final editingEndedAt = EntityEditingEndedAt.build(
        ref.read(envProvider.notifier).get<int>(EnvVariable.EDIT_POST_ALLOWED_MINUTES),
      );

      final postData = ModifiablePostData(
        content: await _buildContentWithMediaLinks(
          content: postContent,
          media: media.values.toList(),
        ),
        media: media,
        replaceableEventId: ReplaceableEventIdentifier.generate(),
        publishedAt: _buildEntityPublishedAt(),
        editingEndedAt: editingEndedAt,
        relatedHashtags: extractTags(postContent).map((tag) => RelatedHashtag(value: tag)).toList(),
        quotedEvent: quotedEvent != null ? _buildQuotedEvent(quotedEvent) : null,
        relatedEvents: parentEntity != null ? _buildRelatedEvents(parentEntity) : null,
        relatedPubkeys: _buildRelatedPubkeys(postContent, parentEntity),
        settings: EntityDataWithSettings.build(whoCanReply: whoCanReply),
        expiration: _buildExpiration(),
        communityId: communityId,
        richText: await _buildRichTextContentWithMediaLinks(
          content: postContent,
          media: media.values.toList(),
        ),
      );

      final posts = await _sendPostEntities([...files, postData]);
      posts?.whereType<ModifiablePostEntity>().forEach(_createPostNotifierStreamController.add);

      if (quotedEvent != null) {
        ref.read(repostsCountProvider(quotedEvent).notifier).addOne();
      }
      if (parentEvent != null) {
        ref.read(repliesCountProvider(parentEvent).notifier).addOne();
      }
    });
  }

  Future<void> modify({
    required EventReference eventReference,
    Delta? content,
    List<MediaFile>? mediaFiles,
    Map<String, MediaAttachment> mediaAttachments = const {},
    WhoCanReplySettingsOption? whoCanReply,
  }) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      final postContent = content ?? buildEmptyDelta();
      final modifiedEntity =
          await ref.read(ionConnectEntityProvider(eventReference: eventReference).future);
      if (modifiedEntity is! ModifiablePostEntity) {
        throw UnsupportedEventReference(eventReference);
      }

      final (:files, :media) = await _uploadMediaFiles(mediaFiles: mediaFiles);
      final modifiedMedia = Map<String, MediaAttachment>.from(mediaAttachments)..addAll(media);
      final originalMediaHashes =
          modifiedEntity.data.media.values.map((e) => e.originalFileHash).toSet();
      final attachedMediaHashes = mediaAttachments.values.map((e) => e.originalFileHash).toSet();
      final removedMediaHashes = originalMediaHashes.difference(attachedMediaHashes).toList();

      final postData = modifiedEntity.data.copyWith(
        content: await _buildContentWithMediaLinks(
          content: postContent,
          media: modifiedMedia.values.toList(),
        ),
        richText: await _buildRichTextContentWithMediaLinks(
          content: postContent,
          media: modifiedMedia.values.toList(),
        ),
        media: modifiedMedia,
        relatedHashtags: extractTags(postContent).map((tag) => RelatedHashtag(value: tag)).toList(),
        settings: EntityDataWithSettings.build(
          whoCanReply: whoCanReply ?? modifiedEntity.data.whoCanReplySetting,
        ),
      );

      await Future.wait([
        ref.read(ionConnectDeleteFileNotifierProvider.notifier).deleteMultiple(removedMediaHashes),
        _sendPostEntities([...files, postData]),
      ]);
    });
  }

  Future<void> softDelete({
    required EventReference eventReference,
  }) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      final entity =
          await ref.read(ionConnectEntityProvider(eventReference: eventReference).future);
      if (entity is! ModifiablePostEntity) {
        throw UnsupportedEventReference(eventReference);
      }

      final postData = entity.data.copyWith(
        content: '',
        editingEndedAt: null,
        relatedHashtags: [],
        relatedPubkeys: [],
        quotedEvent: null,
        media: {},
        settings: null,
        expiration: null,
        richText: null,
      );

      await _sendPostEntities([postData]);
    });
  }

  Future<List<IonConnectEntity>?> _sendPostEntities(List<EventSerializable> entitiesData) async {
    //TODO: check the event json according to notion when defined
    return ref.read(ionConnectNotifierProvider.notifier).sendEntitiesData(entitiesData);
  }

  EntityPublishedAt _buildEntityPublishedAt() {
    return EntityPublishedAt(value: DateTime.now());
  }

  EntityExpiration? _buildExpiration() {
    if (createOption == CreatePostOption.story) {
      return EntityExpiration(
        value: DateTime.now().add(
          Duration(
            hours: ref.read(envProvider.notifier).get<int>(EnvVariable.STORY_EXPIRATION_HOURS),
          ),
        ),
      );
    }
    return null;
  }

  Future<({List<FileMetadata> files, Map<String, MediaAttachment> media})> _uploadMediaFiles({
    List<MediaFile>? mediaFiles,
  }) async {
    final files = <FileMetadata>[];
    final attachments = <MediaAttachment>[];
    if (mediaFiles != null && mediaFiles.isNotEmpty) {
      final results = await Future.wait(
        mediaFiles.map(_uploadMedia),
      );
      for (final result in results) {
        files.addAll(result.fileMetadatas);
        attachments.add(result.mediaAttachment);
      }
    }
    return (
      files: files,
      media: {for (final attachment in attachments) attachment.url: attachment}
    );
  }

  Future<IonConnectEntity?> _getParentEntity(EventReference parentEventReference) async {
    final parentEntity =
        await ref.read(ionConnectEntityProvider(eventReference: parentEventReference).future);
    if (parentEntity == null) {
      throw EntityNotFoundException(parentEventReference);
    }

    if (parentEntity is! ModifiablePostEntity &&
        parentEntity is! ArticleEntity &&
        parentEntity is! PostEntity) {
      throw UnsupportedParentEntity(parentEntity);
    }
    return parentEntity;
  }

  QuotedEvent _buildQuotedEvent(EventReference quotedEventReference) {
    return switch (quotedEventReference) {
      ReplaceableEventReference() => QuotedReplaceableEvent(eventReference: quotedEventReference),
      ImmutableEventReference() => QuotedImmutableEvent(eventReference: quotedEventReference),
      _ => throw UnsupportedEventReference(quotedEventReference)
    };
  }

  Future<RichText> _buildRichTextContentWithMediaLinks({
    required Delta content,
    required List<MediaAttachment> media,
  }) async {
    final contentWithMedia = await _buildContentWithMediaLinksDelta(
      content: content,
      media: media,
    );

    final richText = RichText(
      protocol: 'quill_delta',
      content: jsonEncode(contentWithMedia.toJson()),
    );

    return richText;
  }

  Future<String> _buildContentWithMediaLinks({
    required Delta content,
    required List<MediaAttachment> media,
  }) async {
    final contentWithMediaAndMentions = await _buildContentWithMediaLinksDelta(
      content: content,
      media: media,
    );
    return deltaToMarkdown(contentWithMediaAndMentions);
  }

  Future<Delta> _buildContentWithMediaLinksDelta({
    required Delta content,
    required List<MediaAttachment> media,
  }) async {
    final currentOperations = content.operations.toList();
    final newContentDelta = Delta.fromOperations(currentOperations);

    return Delta.fromOperations(
      media
          .map(
            (mediaItem) => Operation.insert(mediaItem.url, {Attribute.link.key: mediaItem.url}),
          )
          .toList(),
    ).concat(newContentDelta);
  }

  List<RelatedEvent> _buildRelatedEvents(IonConnectEntity parentEntity) {
    final parentEventReference = parentEntity.toEventReference();

    final parentRelatedEvents = switch (parentEntity) {
      ModifiablePostEntity() => parentEntity.data.relatedEvents,
      PostEntity() => parentEntity.data.relatedEvents,
      _ => null,
    };

    final rootParentRelatedEvent = parentRelatedEvents
        ?.firstWhereOrNull((relatedEvent) => relatedEvent.marker == RelatedEventMarker.root);

    if (parentEventReference is ReplaceableEventReference) {
      return [
        rootParentRelatedEvent ??
            RelatedReplaceableEvent(
              eventReference: parentEventReference,
              pubkey: parentEntity.masterPubkey,
              marker: RelatedEventMarker.root,
            ),
        RelatedReplaceableEvent(
          eventReference: parentEventReference,
          pubkey: parentEntity.masterPubkey,
          marker: RelatedEventMarker.reply,
        ),
      ];
    } else if (parentEventReference is ImmutableEventReference) {
      return [
        rootParentRelatedEvent ??
            RelatedImmutableEvent(
              eventReference: parentEventReference,
              pubkey: parentEntity.masterPubkey,
              marker: RelatedEventMarker.root,
            ),
        RelatedImmutableEvent(
          eventReference: parentEventReference,
          pubkey: parentEntity.masterPubkey,
          marker: RelatedEventMarker.reply,
        ),
      ];
    } else {
      throw UnsupportedParentEntity(parentEntity);
    }
  }

  List<RelatedPubkey>? _buildRelatedPubkeys(
    Delta content,
    IonConnectEntity? parentEntity,
  ) {
    final pubkeys = _extractPubkeys(content);
    return <RelatedPubkey>{
      ...pubkeys.map((pubkey) => RelatedPubkey(value: pubkey)),
      if (parentEntity != null) ...{
        RelatedPubkey(value: parentEntity.masterPubkey),
        if (parentEntity is ModifiablePostEntity) ...(parentEntity.data.relatedPubkeys ?? []),
        if (parentEntity is PostEntity) ...(parentEntity.data.relatedPubkeys ?? []),
      },
    }.toList();
  }

  List<String> _extractPubkeys(Delta content) {
    final pubkeys = <String>[];
    for (final op in content.operations) {
      if (op.key == 'insert' && op.data is Map) {
        final attributes = op.data! as Map<String, dynamic>;
        if (attributes.containsKey(textEditorProfileKey)) {
          final encodedRef = attributes[textEditorProfileKey] as String;
          final eventReference = EventReference.fromEncoded(encodedRef);
          pubkeys.add(eventReference.pubkey);
        }
      }
    }
    return pubkeys;
  }

  Future<({List<FileMetadata> fileMetadatas, MediaAttachment mediaAttachment})> _uploadMedia(
    MediaFile mediaFile,
  ) async {
    final mediaType = MediaType.fromMimeType(mediaFile.mimeType ?? '');
    return switch (mediaType) {
      MediaType.image => _uploadImage(mediaFile),
      MediaType.video => _uploadVideo(mediaFile),
      _ => throw UnknownMediaTypeException(),
    };
  }

  Future<({List<FileMetadata> fileMetadatas, MediaAttachment mediaAttachment})> _uploadImage(
    MediaFile file,
  ) async {
    Logger.info(
      'Uploading image: width=${file.width}, height=${file.height}, path=${file.path}',
    );

    var compressedImage = file;

    // Compress image if it's not a story
    // The stories has its own compression logic in ImageProcessorNotifier

    if (createOption != CreatePostOption.story) {
      compressedImage = await ref.read(imageCompressorProvider).compress(
            file,
            settings: const ImageCompressionSettings(shouldCompressGif: true),
          );
    }

    final uploadResult = await ref.read(ionConnectUploadNotifierProvider.notifier).upload(
          compressedImage,
          alt: _getFileAlt(),
        );

    Logger.info(
      'Image uploaded successfully: fileUrl=${uploadResult.fileMetadata.url}',
    );

    return (
      fileMetadatas: [uploadResult.fileMetadata],
      mediaAttachment: uploadResult.mediaAttachment
    );
  }

  Future<({List<FileMetadata> fileMetadatas, MediaAttachment mediaAttachment})> _uploadVideo(
    MediaFile file,
  ) async {
    final videoCompressor = ref.read(videoCompressorProvider);
    final compressedVideo = await videoCompressor.compress(file);

    final videoUploadResult = await ref
        .read(ionConnectUploadNotifierProvider.notifier)
        .upload(compressedVideo, alt: _getFileAlt());

    final thumbImage = await videoCompressor.getThumbnail(compressedVideo, thumb: file.thumb);

    final thumbUploadResult = await ref
        .read(ionConnectUploadNotifierProvider.notifier)
        .upload(thumbImage, alt: _getFileAlt());

    final thumbUrl = thumbUploadResult.fileMetadata.url;

    final mediaAttachment =
        videoUploadResult.mediaAttachment.copyWith(thumb: thumbUrl, image: thumbUrl);

    final videoFileMetadata =
        videoUploadResult.fileMetadata.copyWith(thumb: thumbUrl, image: thumbUrl);

    return (
      fileMetadatas: [videoFileMetadata, thumbUploadResult.fileMetadata],
      mediaAttachment: mediaAttachment
    );
  }

  FileAlt _getFileAlt() {
    return switch (createOption) {
      CreatePostOption.video => FileAlt.video,
      CreatePostOption.story => FileAlt.story,
      _ => FileAlt.post
    };
  }
}
