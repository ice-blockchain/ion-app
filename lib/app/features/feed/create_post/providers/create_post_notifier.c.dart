// SPDX-License-Identifier: ice License 1.0

import 'package:collection/collection.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/quill_delta.dart';
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
import 'package:ion/app/features/ion_connect/providers/ion_connect_entity_provider.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_notifier.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_upload_notifier.c.dart';
import 'package:ion/app/services/compressor/compress_service.c.dart';
import 'package:ion/app/services/logger/logger.dart';
import 'package:ion/app/services/markdown/quill.dart';
import 'package:ion/app/services/media_service/media_service.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'create_post_notifier.c.g.dart';

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
    String? communtiyId,
  }) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      final postContent = content ?? Delta();
      final parentEntity = parentEvent != null ? await _getParentEntity(parentEvent) : null;
      final (:files, :media) = await _uploadMediaFiles(mediaFiles: mediaFiles);

      final postData = ModifiablePostData(
        content: _buildContentWithMediaLinks(content: postContent, media: media.values.toList()),
        media: media,
        replaceableEventId: ReplaceableEventIdentifier.generate(),
        publishedAt: _buildEntityPublishedAt(),
        editingEndedAt: _buildEntityEditingEndedAt(),
        relatedHashtags: extractTags(postContent).map((tag) => RelatedHashtag(value: tag)).toList(),
        quotedEvent: quotedEvent != null ? _buildQuotedEvent(quotedEvent) : null,
        relatedEvents: parentEntity != null ? _buildRelatedEvents(parentEntity) : null,
        relatedPubkeys: parentEntity != null ? _buildRelatedPubkeys(parentEntity) : null,
        settings: EntityDataWithSettings.build(whoCanReply: whoCanReply),
        expiration: _buildExpiration(),
        communityId: communtiyId,
      );

      await _sendPostEntities([...files, postData]);

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
    WhoCanReplySettingsOption? whoCanReply,
  }) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      final postContent = content ?? Delta();
      final modifiedEntity =
          await ref.read(ionConnectEntityProvider(eventReference: eventReference).future);
      if (modifiedEntity is! ModifiablePostEntity) {
        throw UnsupportedEventReference(eventReference);
      }

      final postData = modifiedEntity.data.copyWith(
        content: _buildContentWithMediaLinks(
          content: postContent,
          media: modifiedEntity.data.media.values.toList(),
        ),
        relatedHashtags: extractTags(postContent).map((tag) => RelatedHashtag(value: tag)).toList(),
        settings: EntityDataWithSettings.build(
          whoCanReply: whoCanReply ?? modifiedEntity.data.whoCanReplySetting,
        ),
      );

      await _sendPostEntities([postData]);
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
        media: {}, //TODO: consider removing media from the storage
        settings: null,
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

  EntityEditingEndedAt _buildEntityEditingEndedAt() {
    return EntityEditingEndedAt(
      value: DateTime.now().add(
        Duration(
          minutes: ref.read(envProvider.notifier).get<int>(EnvVariable.EDIT_POST_ALLOWED_MINUTES),
        ),
      ),
    );
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
      await Future.wait(
        mediaFiles.map((mediaFile) async {
          final (:fileMetadatas, :mediaAttachment) = await _uploadMedia(mediaFile);
          attachments.add(mediaAttachment);
          files.addAll(fileMetadatas);
        }),
      );
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

  String _buildContentWithMediaLinks({
    required Delta content,
    required List<MediaAttachment> media,
  }) {
    final contentWithMedia = Delta.fromOperations(
      media
          .map(
            (mediaItem) => Operation.insert(mediaItem.url, {Attribute.link.key: mediaItem.url}),
          )
          .toList(),
    ).concat(content);
    return deltaToMarkdown(contentWithMedia);
  }

  List<RelatedEvent> _buildRelatedEvents(IonConnectEntity parentEntity) {
    if (parentEntity is ArticleEntity) {
      return [
        RelatedReplaceableEvent(
          eventReference: parentEntity.toEventReference(),
          pubkey: parentEntity.masterPubkey,
          marker: RelatedEventMarker.root,
        ),
      ];
    } else if (parentEntity is ModifiablePostEntity) {
      final rootRelatedEvent = parentEntity.data.relatedEvents
          ?.firstWhereOrNull((relatedEvent) => relatedEvent.marker == RelatedEventMarker.root);
      return [
        if (rootRelatedEvent != null) rootRelatedEvent,
        RelatedReplaceableEvent(
          eventReference: parentEntity.toEventReference(),
          pubkey: parentEntity.masterPubkey,
          marker: rootRelatedEvent != null ? RelatedEventMarker.reply : RelatedEventMarker.root,
        ),
      ];
    } else if (parentEntity is PostEntity) {
      final rootRelatedEvent = parentEntity.data.relatedEvents
          ?.firstWhereOrNull((relatedEvent) => relatedEvent.marker == RelatedEventMarker.root);
      return [
        if (rootRelatedEvent != null) rootRelatedEvent,
        RelatedImmutableEvent(
          eventReference: parentEntity.toEventReference(),
          pubkey: parentEntity.masterPubkey,
          marker: rootRelatedEvent != null ? RelatedEventMarker.reply : RelatedEventMarker.root,
        ),
      ];
    } else {
      throw UnsupportedParentEntity(parentEntity);
    }
  }

  List<RelatedPubkey> _buildRelatedPubkeys(IonConnectEntity parentEntity) {
    return [
      RelatedPubkey(value: parentEntity.masterPubkey),
      if (parentEntity is ModifiablePostEntity) ...(parentEntity.data.relatedPubkeys ?? []),
      if (parentEntity is PostEntity) ...(parentEntity.data.relatedPubkeys ?? []),
    ];
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

    final uploadResult = await ref.read(ionConnectUploadNotifierProvider.notifier).upload(
          file,
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
    final compressedVideo = await ref.read(compressServiceProvider).compressVideo(file);

    final videoUploadResult = await ref
        .read(ionConnectUploadNotifierProvider.notifier)
        .upload(compressedVideo, alt: _getFileAlt());

    final thumbImage =
        await ref.read(compressServiceProvider).getThumbnail(compressedVideo, thumb: file.thumb);

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
