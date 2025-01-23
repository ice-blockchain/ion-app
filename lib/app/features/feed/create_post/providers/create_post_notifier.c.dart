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
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';
import 'package:ion/app/features/ion_connect/model/event_setting.c.dart';
import 'package:ion/app/features/ion_connect/model/file_alt.dart';
import 'package:ion/app/features/ion_connect/model/file_metadata.c.dart';
import 'package:ion/app/features/ion_connect/model/ion_connect_entity.dart';
import 'package:ion/app/features/ion_connect/model/media_attachment.dart';
import 'package:ion/app/features/ion_connect/model/quoted_replaceable_event.c.dart';
import 'package:ion/app/features/ion_connect/model/related_event_marker.dart';
import 'package:ion/app/features/ion_connect/model/related_hashtag.c.dart';
import 'package:ion/app/features/ion_connect/model/related_pubkey.c.dart';
import 'package:ion/app/features/ion_connect/model/related_replaceable_event.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_entity_provider.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_notifier.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_upload_notifier.c.dart';
import 'package:ion/app/services/compressor/compress_service.c.dart';
import 'package:ion/app/services/media_service/media_service.c.dart';
import 'package:ion/app/services/text_parser/model/text_match.c.dart';
import 'package:ion/app/services/text_parser/model/text_matcher.dart';
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
    List<MediaFile>? mediaFiles,
  }) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      var data = ModifiablePostData.fromRawContent(content.trim());

      data = data.copyWith(
        editingEndedAt: EntityEditingEndedAt(
          value: DateTime.now().add(
            Duration(
              minutes:
                  ref.read(envProvider.notifier).get<int>(EnvVariable.EDIT_POST_ALLOWED_MINUTES),
            ),
          ),
        ),
      );

      if (whoCanReply != WhoCanReplySettingsOption.everyone) {
        data = data.copyWith(
          settings: [
            WhoCanReplyEventSetting(values: {whoCanReply}),
          ],
        );
      }

      final files = <FileMetadata>[];
      if (mediaFiles != null) {
        final attachments = <MediaAttachment>[];
        await Future.wait(
          mediaFiles.map((mediaFile) async {
            final (:fileMetadatas, :mediaAttachment) = await _uploadMedia(mediaFile);
            attachments.add(mediaAttachment);
            files.addAll(fileMetadatas);
          }),
        );

        data = data.copyWith(
          content: [
            ...attachments.map(
              (attachment) {
                final spaceSeparator = data.content.isNotEmpty ? ' ' : '';
                return TextMatch('${attachment.url}$spaceSeparator');
              },
            ),
            ...data.content,
          ],
          media: {for (final attachment in attachments) attachment.url: attachment},
        );
      }

      if (quotedEvent != null) {
        if (quotedEvent is ReplaceableEventReference) {
          data = data.copyWith(
            quotedEvent:
                QuotedReplaceableEvent(eventReference: quotedEvent, pubkey: quotedEvent.pubkey),
          );
        } else {
          throw UnimplementedError();
        }
      }

      if (parentEvent != null) {
        if (parentEvent is ReplaceableEventReference) {
          final parentEntity =
              await ref.read(ionConnectEntityProvider(eventReference: parentEvent).future);
          if (parentEntity == null) {
            throw EventNotFoundException(parentEvent);
          }
          if (parentEntity is! ModifiablePostEntity && parentEntity is! ArticleEntity) {
            throw UnsupportedParentEntity(parentEvent);
          }
          data = data.copyWith(
            relatedEvents: _buildRelatedEvents(parentEntity),
            relatedPubkeys: _buildRelatedPubkeys(parentEntity),
          );
        } else {
          throw UnimplementedError();
        }
      }

      data = data.copyWith(relatedHashtags: _buildRelatedHashtags(data.content));

      if (createOption == CreatePostOption.story) {
        data = data.copyWith(
          expiration: EntityExpiration(
            value: DateTime.now().add(
              Duration(
                hours: ref.read(envProvider.notifier).get<int>(EnvVariable.STORY_EXPIRATION_HOURS),
              ),
            ),
          ),
        );
      }

      //TODO: check the event json according to notion when defined
      await ref.read(ionConnectNotifierProvider.notifier).sendEntitiesData([...files, data]);

      if (quotedEvent != null) {
        ref.read(repostsCountProvider(quotedEvent).notifier).addOne();
      }
      if (parentEvent != null) {
        ref.read(repliesCountProvider(parentEvent).notifier).addOne();
      }
    });
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
