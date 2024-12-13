// SPDX-License-Identifier: ice License 1.0

import 'package:collection/collection.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/data/models/entities/article_data.c.dart';
import 'package:ion/app/features/feed/data/models/entities/post_data.c.dart';
import 'package:ion/app/features/feed/data/models/entities/related_event.c.dart';
import 'package:ion/app/features/feed/data/models/entities/related_hashtag.c.dart';
import 'package:ion/app/features/feed/data/models/entities/related_pubkey.c.dart';
import 'package:ion/app/features/feed/providers/counters/replies_count_provider.c.dart';
import 'package:ion/app/features/feed/providers/counters/reposts_count_provider.c.dart';
import 'package:ion/app/features/gallery/providers/gallery_provider.c.dart';
import 'package:ion/app/features/nostr/model/event_reference.c.dart';
import 'package:ion/app/features/nostr/model/file_alt.dart';
import 'package:ion/app/features/nostr/model/file_metadata.c.dart';
import 'package:ion/app/features/nostr/model/media_attachment.dart';
import 'package:ion/app/features/nostr/model/nostr_entity.dart';
import 'package:ion/app/features/nostr/providers/nostr_entity_provider.c.dart';
import 'package:ion/app/features/nostr/providers/nostr_notifier.c.dart';
import 'package:ion/app/features/nostr/providers/nostr_upload_notifier.c.dart';
import 'package:ion/app/services/compressor/compress_service.c.dart';
import 'package:ion/app/services/media_service/media_service.c.dart';
import 'package:ion/app/services/text_parser/text_match.dart';
import 'package:ion/app/services/text_parser/text_matcher.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'create_post_notifier.c.g.dart';

@Riverpod(dependencies: [nostrEntity])
class CreatePostNotifier extends _$CreatePostNotifier {
  @override
  FutureOr<void> build() {}

  Future<void> create({
    required String content,
    EventReference? parentEvent,
    EventReference? quotedEvent,
    List<String>? mediaIds,
  }) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      var data = PostData.fromRawContent(content.trim());
      final files = <FileMetadata>[];

      if (mediaIds != null) {
        final attachments = <MediaAttachment>[];
        await Future.wait(
          mediaIds.map((id) async {
            final (:fileMetadatas, :mediaAttachment) = await _uploadMedia(id);
            attachments.add(mediaAttachment);
            files.addAll(fileMetadatas);
          }),
        );

        data = data.copyWith(
          content: [
            ...attachments.map((attachment) => TextMatch('${attachment.url} ')),
            ...data.content,
          ],
          media: {for (final attachment in attachments) attachment.url: attachment},
        );
      }

      if (quotedEvent != null) {
        data = data.copyWith(
          quotedEvent: QuotedEvent(eventId: quotedEvent.eventId, pubkey: quotedEvent.pubkey),
        );
      }

      if (parentEvent != null) {
        final parentEntity =
            await ref.read(nostrEntityProvider(eventReference: parentEvent).future);
        if (parentEntity == null) {
          throw EventNotFoundException(eventId: parentEvent.eventId, pubkey: parentEvent.pubkey);
        }
        if (parentEntity is! PostEntity || parentEntity is! ArticleEntity) {
          throw UnsupportedParentEntity(eventId: parentEvent.eventId);
        }
        data = data.copyWith(
          relatedEvents: _buildRelatedEvents(parentEntity),
          relatedPubkeys: _buildRelatedPubkeys(parentEntity),
        );
      }

      data = data.copyWith(relatedHashtags: _buildRelatedHashtags(data.content));

      //TODO: check the event json according to notion when defined
      await ref.read(nostrNotifierProvider.notifier).sendEntitiesData([...files, data]);

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

  List<RelatedEvent> _buildRelatedEvents(NostrEntity parentEntity) {
    if (parentEntity is ArticleEntity) {
      return [
        RelatedEvent(
          eventId: parentEntity.id,
          pubkey: parentEntity.masterPubkey,
          marker: RelatedEventMarker.root,
        ),
      ];
    } else if (parentEntity is PostEntity) {
      final rootRelatedEvent = parentEntity.data.relatedEvents
          ?.firstWhereOrNull((relatedEvent) => relatedEvent.marker == RelatedEventMarker.root);
      return [
        if (rootRelatedEvent != null) rootRelatedEvent,
        RelatedEvent(
          eventId: parentEntity.id,
          pubkey: parentEntity.masterPubkey,
          marker: rootRelatedEvent != null ? RelatedEventMarker.reply : RelatedEventMarker.root,
        ),
      ];
    } else {
      throw UnsupportedParentEntity(eventId: parentEntity.id);
    }
  }

  List<RelatedPubkey> _buildRelatedPubkeys(NostrEntity parentEntity) {
    if (parentEntity is ArticleEntity) {
      return [RelatedPubkey(value: parentEntity.masterPubkey)];
    } else if (parentEntity is PostEntity) {
      return <RelatedPubkey>{
        RelatedPubkey(value: parentEntity.masterPubkey),
        ...parentEntity.data.relatedPubkeys ?? [],
      }.toList();
    } else {
      throw UnsupportedParentEntity(eventId: parentEntity.id);
    }
  }

  Future<({List<FileMetadata> fileMetadatas, MediaAttachment mediaAttachment})> _uploadMedia(
    String mediaId,
  ) async {
    final assetEntity = await ref.read(assetEntityProvider(mediaId).future);
    if (assetEntity == null) {
      throw AssetEntityFileNotFoundException();
    }

    final file = await assetEntity.file;

    if (file == null) {
      throw AssetEntityFileNotFoundException();
    }

    final mediaFile =
        MediaFile(path: file.path, width: assetEntity.width, height: assetEntity.height);

    return switch (assetEntity.type) {
      AssetType.image => _uploadImage(mediaFile),
      AssetType.video => _uploadVideo(mediaFile),
      _ => throw UnsupportedMediaTypeException(assetEntity.type.toShortString()),
    };
  }

  Future<({List<FileMetadata> fileMetadatas, MediaAttachment mediaAttachment})> _uploadImage(
    MediaFile file,
  ) async {
    const maxDimension = 1024;
    final MediaFile(:height, :width) = file;

    if (height == null || width == null) {
      throw UnknownUploadFileResolutionException();
    }

    final compressedImage = await ref.read(compressServiceProvider).compressImage(
          MediaFile(path: file.path),
          // Do not pass the second dimension to keep the aspect ratio
          width: width > height ? maxDimension : null,
          height: height > width ? maxDimension : null,
          quality: 70,
        );

    final uploadResult = await ref
        .read(nostrUploadNotifierProvider.notifier)
        .upload(compressedImage, alt: FileAlt.post);

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
        .read(nostrUploadNotifierProvider.notifier)
        .upload(compressedVideo, alt: FileAlt.post);

    final thumbImage = await ref.read(compressServiceProvider).getThumbnail(compressedVideo);

    final thumbUploadResult =
        await ref.read(nostrUploadNotifierProvider.notifier).upload(thumbImage, alt: FileAlt.post);

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
}
