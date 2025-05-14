// SPDX-License-Identifier: ice License 1.0

import 'dart:async';
import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/quill_delta.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/text_editor/utils/build_empty_delta.dart';
import 'package:ion/app/components/text_editor/utils/extract_tags.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/extensions/delta.dart';
import 'package:ion/app/features/core/model/media_type.dart';
import 'package:ion/app/features/core/providers/env_provider.c.dart';
import 'package:ion/app/features/feed/create_post/model/create_post_option.dart';
import 'package:ion/app/features/feed/data/models/entities/article_data.c.dart';
import 'package:ion/app/features/feed/data/models/entities/modifiable_post_data.c.dart';
import 'package:ion/app/features/feed/data/models/entities/post_data.c.dart';
import 'package:ion/app/features/feed/data/models/who_can_reply_settings_option.dart';
import 'package:ion/app/features/feed/providers/counters/replies_count_provider.c.dart';
import 'package:ion/app/features/feed/providers/counters/reposts_count_provider.c.dart';
import 'package:ion/app/features/ion_connect/model/action_source.c.dart';
import 'package:ion/app/features/ion_connect/model/entity_data_with_settings.dart';
import 'package:ion/app/features/ion_connect/model/entity_editing_ended_at.c.dart';
import 'package:ion/app/features/ion_connect/model/entity_expiration.c.dart';
import 'package:ion/app/features/ion_connect/model/entity_published_at.c.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';
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
import 'package:ion/app/features/user/providers/user_events_metadata_provider.c.dart';
import 'package:ion/app/services/compressors/image_compressor.c.dart';
import 'package:ion/app/services/compressors/video_compressor.c.dart';
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
      final mentions = _buildMentions(postContent);

      final postData = ModifiablePostData(
        // content: '',
        media: media,
        replaceableEventId: ReplaceableEventIdentifier.generate(),
        publishedAt: _buildEntityPublishedAt(),
        editingEndedAt: _buildEditingEndedAt(),
        relatedHashtags: extractTags(postContent).map((tag) => RelatedHashtag(value: tag)).toList(),
        quotedEvent: quotedEvent != null ? _buildQuotedEvent(quotedEvent) : null,
        relatedEvents: parentEntity != null ? _buildRelatedEvents(parentEntity) : null,
        relatedPubkeys: _buildRelatedPubkeys(mentions: mentions, parentEntity: parentEntity),
        settings: EntityDataWithSettings.build(whoCanReply: whoCanReply),
        expiration: _buildExpiration(),
        communityId: communityId,
        richText: await _buildRichTextContentWithMediaLinks(
          content: postContent,
          media: media.values.toList(),
        ),
      );

      final post = await _publishPost(
        postData,
        files: files,
        mentions: mentions,
        quotedEvent: quotedEvent,
        parentEvent: parentEvent,
      );

      _createPostNotifierStreamController.add(post);

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
    // New media files added during the editing
    List<MediaFile>? mediaFiles,
    // Media attachments left from the original post
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

      final parentEvent = modifiedEntity.data.parentEvent?.eventReference;
      final quotedEvent = modifiedEntity.data.quotedEvent?.eventReference;
      final parentEntity = parentEvent != null ? await _getParentEntity(parentEvent) : null;
      final mentions = _buildMentions(postContent);

      final (:files, :media) = await _uploadMediaFiles(mediaFiles: mediaFiles);
      final modifiedMedia = Map<String, MediaAttachment>.from(mediaAttachments)..addAll(media);

      final postData = modifiedEntity.data.copyWith(
        // content: await _buildContentWithMediaLinks(
        //   content: postContent,
        //   media: modifiedMedia.values.toList(),
        // ),
        richText: await _buildRichTextContentWithMediaLinks(
          content: postContent,
          media: modifiedMedia.values.toList(),
        ),
        media: modifiedMedia,
        relatedHashtags: extractTags(postContent).map((tag) => RelatedHashtag(value: tag)).toList(),
        relatedPubkeys:
            _buildRelatedPubkeys(mentions: _buildMentions(postContent), parentEntity: parentEntity),
        settings: EntityDataWithSettings.build(
          whoCanReply: whoCanReply ?? modifiedEntity.data.whoCanReplySetting,
        ),
      );

      final originalContentDelta = parseAndConvertDelta(
        modifiedEntity.data.richText?.content,
        modifiedEntity.data.content,
      );

      final originalMentions = _buildMentions(originalContentDelta);

      final removedMediaHashes = _buildRemovedMediaHashes(
        post: modifiedEntity,
        mediaAttachments: mediaAttachments.values.toList(),
      );

      await Future.wait([
        ref.read(ionConnectDeleteFileNotifierProvider.notifier).deleteMultiple(removedMediaHashes),
        _publishPost(
          postData,
          files: files,
          mentions: <RelatedPubkey>{...originalMentions, ...mentions}.toList(),
          quotedEvent: quotedEvent,
          parentEvent: parentEvent,
        ),
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
        // content: '',
        editingEndedAt: null,
        relatedHashtags: [],
        relatedPubkeys: [],
        quotedEvent: null,
        media: {},
        settings: null,
        expiration: null,
        richText: null,
      );

      final contentDelta = parseAndConvertDelta(
        entity.data.richText?.content,
        entity.data.content,
      );

      final removedMediaHashes = _buildRemovedMediaHashes(post: entity, mediaAttachments: []);

      await Future.wait([
        ref.read(ionConnectDeleteFileNotifierProvider.notifier).deleteMultiple(removedMediaHashes),
        _publishPost(
          postData,
          mentions: _buildMentions(contentDelta),
          quotedEvent: entity.data.quotedEvent?.eventReference,
          parentEvent: entity.data.parentEvent?.eventReference,
        ),
      ]);
    });
  }

  Future<ModifiablePostEntity> _publishPost(
    ModifiablePostData postData, {
    EventReference? quotedEvent,
    EventReference? parentEvent,
    List<FileMetadata> files = const [],
    List<RelatedPubkey> mentions = const [],
  }) async {
    final ionNotifier = ref.read(ionConnectNotifierProvider.notifier);

    final postEvent = await ionNotifier.sign(postData);
    final fileEvents = await Future.wait(files.map(ionNotifier.sign));
    final eventsToPublish = [...fileEvents, postEvent];

    final pubkeysToPublish = mentions.map((mention) => mention.value).toSet();

    if (quotedEvent != null) {
      pubkeysToPublish.add(quotedEvent.pubkey);
    } else if (parentEvent != null) {
      pubkeysToPublish.add(parentEvent.pubkey);
    }

    final userEventsMetadataBuilder = await ref.read(userEventsMetadataBuilderProvider.future);

    await Future.wait([
      ionNotifier.sendEvents(eventsToPublish),
      for (final pubkey in pubkeysToPublish)
        ref.read(ionConnectNotifierProvider.notifier).sendEvents(
              eventsToPublish,
              actionSource: ActionSourceUser(pubkey),
              metadataBuilders: [userEventsMetadataBuilder],
              cache: false,
            ),
    ]);

    return ModifiablePostEntity.fromEventMessage(postEvent);
  }

  EntityPublishedAt _buildEntityPublishedAt() {
    return EntityPublishedAt(value: DateTime.now());
  }

  EntityEditingEndedAt _buildEditingEndedAt() {
    return EntityEditingEndedAt.build(
      ref.read(envProvider.notifier).get<int>(EnvVariable.EDIT_POST_ALLOWED_MINUTES),
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
    final newContentDelta = flattenLinks(content);

    return Delta.fromOperations(
      media
          .map(
            (mediaItem) => Operation.insert(' ', {Attribute.link.key: mediaItem.url}),
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

  List<RelatedPubkey> _buildMentions(Delta content) {
    return content.extractPubkeys().map((pubkey) => RelatedPubkey(value: pubkey)).toList();
  }

  List<RelatedPubkey> _buildRelatedPubkeys({
    required List<RelatedPubkey> mentions,
    IonConnectEntity? parentEntity,
  }) {
    return <RelatedPubkey>{
      ...mentions,
      if (parentEntity != null) ...{
        RelatedPubkey(value: parentEntity.masterPubkey),
        if (parentEntity is ModifiablePostEntity) ...(parentEntity.data.relatedPubkeys ?? []),
        if (parentEntity is PostEntity) ...(parentEntity.data.relatedPubkeys ?? []),
      },
    }.toList();
  }

  List<String> _buildRemovedMediaHashes({
    required ModifiablePostEntity post,
    required List<MediaAttachment> mediaAttachments,
  }) {
    final originalMediaHashes = post.data.media.values.map((e) => e.originalFileHash).toSet();
    final attachedMediaHashes = mediaAttachments.map((e) => e.originalFileHash).toSet();
    return originalMediaHashes.difference(attachedMediaHashes).toList();
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
