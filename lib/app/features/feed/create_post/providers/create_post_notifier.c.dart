// SPDX-License-Identifier: ice License 1.0

import 'package:collection/collection.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/core/model/media_type.dart';
import 'package:ion/app/features/core/providers/env_provider.c.dart';
import 'package:ion/app/features/feed/create_post/model/create_post_option.dart';
import 'package:ion/app/features/feed/data/models/entities/article_data.c.dart';
import 'package:ion/app/features/feed/data/models/entities/modifiable_post_data.c.dart';
import 'package:ion/app/features/feed/data/models/who_can_reply_settings_option.dart';
import 'package:ion/app/features/feed/providers/counters/replies_count_provider.c.dart';
import 'package:ion/app/features/feed/providers/counters/reposts_count_provider.c.dart';
import 'package:ion/app/features/ion_connect/model/entity_editing_ended_at.c.dart';
import 'package:ion/app/features/ion_connect/model/entity_expiration.c.dart';
import 'package:ion/app/features/ion_connect/model/entity_published_at.c.dart';
import 'package:ion/app/features/ion_connect/model/entity_settings_data.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';
import 'package:ion/app/features/ion_connect/model/file_alt.dart';
import 'package:ion/app/features/ion_connect/model/file_metadata.c.dart';
import 'package:ion/app/features/ion_connect/model/ion_connect_entity.dart';
import 'package:ion/app/features/ion_connect/model/media_attachment.dart';
import 'package:ion/app/features/ion_connect/model/quoted_replaceable_event.c.dart';
import 'package:ion/app/features/ion_connect/model/related_event_marker.dart';
import 'package:ion/app/features/ion_connect/model/related_hashtag.c.dart';
import 'package:ion/app/features/ion_connect/model/related_pubkey.c.dart';
import 'package:ion/app/features/ion_connect/model/related_replaceable_event.c.dart';
import 'package:ion/app/features/ion_connect/model/replaceable_event_identifier.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_entity_provider.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_notifier.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_upload_notifier.c.dart';
import 'package:ion/app/services/compressor/compress_service.c.dart';
import 'package:ion/app/services/media_service/media_service.c.dart';
import 'package:ion/app/services/text_parser/model/text_match.c.dart';
import 'package:ion/app/services/text_parser/model/text_matcher.dart';
import 'package:ion/app/services/text_parser/text_parser.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'create_post_notifier.c.g.dart';

@riverpod
class CreatePostNotifier extends _$CreatePostNotifier {
  @override
  FutureOr<void> build(CreatePostOption createOption) {}

  Future<void> create({
    required String content,
    required WhoCanReplySettingsOption whoCanReply,
    EventReference? parentEvent,
    EventReference? quotedEvent,
    EventReference? modifiedEvent,
    List<MediaFile>? mediaFiles,
  }) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      final parsedContent = TextParser.allMatchers().parse(content.trim());

      final parentEntity = parentEvent != null ? await _getParentEntity(parentEvent) : null;
      final modifiedEntity = modifiedEvent != null ? await _getModifiedEntity(modifiedEvent) : null;
      final (:files, :media) =
          await _buildMediaAttachments(mediaFiles: mediaFiles, modifiedEntity: modifiedEntity);

      final postData = ModifiablePostData(
        content: _buildContentWithMediaLinks(content: parsedContent, media: media.values.toList()),
        media: media,
        replaceableEventId: modifiedEntity != null
            ? modifiedEntity.data.replaceableEventId
            : ReplaceableEventIdentifier.generate(),
        publishedAt:
            modifiedEntity != null ? modifiedEntity.data.publishedAt : _buildEntityPublishedAt(),
        editingEndedAt: modifiedEntity != null
            ? modifiedEntity.data.editingEndedAt
            : _buildEntityEditingEndedAt(),
        relatedHashtags: _buildRelatedHashtags(parsedContent),
        quotedEvent: quotedEvent != null ? _buildQuotedEvent(quotedEvent) : null,
        relatedEvents: parentEntity != null ? _buildRelatedEvents(parentEntity) : null,
        relatedPubkeys: parentEntity != null ? _buildRelatedPubkeys(parentEntity) : null,
        settings: EntitySettingsDataMixin.build(whoCanReply: whoCanReply),
        expiration: _buildExpiration(),
      );

      //TODO: check the event json according to notion when defined
      await ref.read(ionConnectNotifierProvider.notifier).sendEntitiesData([...files, postData]);

      if (quotedEvent != null) {
        ref.read(repostsCountProvider(quotedEvent).notifier).addOne();
      }
      if (parentEvent != null) {
        ref.read(repliesCountProvider(parentEvent).notifier).addOne();
      }
    });
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

  Future<({List<FileMetadata> files, Map<String, MediaAttachment> media})> _buildMediaAttachments({
    List<MediaFile>? mediaFiles,
    IonConnectEntity? modifiedEntity,
  }) async {
    if (modifiedEntity != null) {
      if (modifiedEntity is! ModifiablePostEntity) {
        throw UnsupportedEventReference(modifiedEntity);
      }
      // Copy media from the modified entity because we don't allow to edit attachments
      return (files: <FileMetadata>[], media: modifiedEntity.data.media);
    } else {
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
  }

  Future<IonConnectEntity?> _getParentEntity(EventReference parentEventReference) async {
    if (parentEventReference is ReplaceableEventReference) {
      final parentEntity =
          await ref.read(ionConnectEntityProvider(eventReference: parentEventReference).future);
      if (parentEntity == null) {
        throw EntityNotFoundException(parentEventReference);
      }
      if (parentEntity is! ModifiablePostEntity && parentEntity is! ArticleEntity) {
        throw UnsupportedParentEntity(parentEntity);
      }
      return parentEntity;
    } else {
      throw UnsupportedEventReference(parentEventReference);
    }
  }

  Future<ModifiablePostEntity> _getModifiedEntity(EventReference modifiedEventReference) async {
    final modifiableEntity =
        await ref.read(ionConnectEntityProvider(eventReference: modifiedEventReference).future);
    if (modifiableEntity == null || modifiableEntity is! ModifiablePostEntity) {
      throw UnsupportedEventReference(modifiedEventReference);
    }
    return modifiableEntity;
  }

  QuotedReplaceableEvent _buildQuotedEvent(EventReference quotedEventReference) {
    if (quotedEventReference is ReplaceableEventReference) {
      return QuotedReplaceableEvent(
        eventReference: quotedEventReference,
        pubkey: quotedEventReference.pubkey,
      );
    } else {
      throw UnsupportedEventReference(quotedEventReference);
    }
  }

  List<TextMatch> _buildContentWithMediaLinks({
    required List<TextMatch> content,
    required List<MediaAttachment> media,
  }) {
    return [
      if (media.isNotEmpty) TextMatch(media.map((attachment) => attachment.url).join(' ')),
      if (media.isNotEmpty && content.isNotEmpty) const TextMatch(' '),
      ...content,
    ];
  }

  List<RelatedHashtag> _buildRelatedHashtags(List<TextMatch> content) {
    return [
      for (final match in content)
        if (match.matcher is HashtagMatcher) RelatedHashtag(value: match.text),
    ];
  }

  List<RelatedReplaceableEvent> _buildRelatedEvents(IonConnectEntity parentEntity) {
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
    } else {
      throw UnsupportedParentEntity(parentEntity);
    }
  }

  List<RelatedPubkey> _buildRelatedPubkeys(IonConnectEntity parentEntity) {
    if (parentEntity is ArticleEntity) {
      return [RelatedPubkey(value: parentEntity.masterPubkey)];
    } else if (parentEntity is ModifiablePostEntity) {
      return <RelatedPubkey>{
        RelatedPubkey(value: parentEntity.masterPubkey),
        ...parentEntity.data.relatedPubkeys ?? [],
      }.toList();
    } else {
      throw UnsupportedParentEntity(parentEntity);
    }
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
    const maxDimension = 1024;
    final (:width, :height) =
        await ref.read(compressServiceProvider).getImageDimension(path: file.path);

    final compressedImage = await ref.read(compressServiceProvider).compressImage(
          file,
          width: width > height ? maxDimension : null,
          height: height > width ? maxDimension : null,
          quality: 70,
        );

    final uploadResult = await ref
        .read(ionConnectUploadNotifierProvider.notifier)
        .upload(compressedImage, alt: _getFileAlt());

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
