// SPDX-License-Identifier: ice License 1.0

import 'package:collection/collection.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/feed/data/models/entities/related_event.dart';
import 'package:ion/app/features/feed/data/models/entities/related_hashtag.dart';
import 'package:ion/app/features/feed/data/models/entities/related_pubkey.dart';
import 'package:ion/app/features/feed/data/models/post_data.dart';
import 'package:ion/app/features/gallery/providers/gallery_provider.dart';
import 'package:ion/app/features/nostr/model/event_reference.dart';
import 'package:ion/app/features/nostr/model/file_metadata.dart';
import 'package:ion/app/features/nostr/model/media_attachment.dart';
import 'package:ion/app/features/nostr/providers/nostr_entity_provider.dart';
import 'package:ion/app/features/nostr/providers/nostr_notifier.dart';
import 'package:ion/app/features/nostr/providers/nostr_upload_notifier.dart';
import 'package:ion/app/services/media_service/media_compress_service.dart';
import 'package:ion/app/services/media_service/media_service.dart';
import 'package:ion/app/services/text_parser/matchers/hashtag_matcher.dart';
import 'package:ion/app/services/text_parser/text_match.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'create_post_notifier.g.dart';

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
            final (fileMetadata, mediaAttachment) = await _uploadImage(id);
            attachments.add(mediaAttachment);
            files.add(fileMetadata);
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
        if (parentEntity is! PostEntity) {
          throw IncorrectEventKindException(eventId: parentEvent.eventId, kind: PostEntity.kind);
        }
        data = data.copyWith(
          relatedEvents: _buildRelatedEvents(parentEntity),
          relatedPubkeys: _buildRelatedPubkeys(parentEntity),
        );
      }

      data = data.copyWith(relatedHashtags: _buildRelatedHashtags(data.content));

      await ref.read(nostrNotifierProvider.notifier).sendEntitiesData([...files, data]);
    });
  }

  List<RelatedHashtag> _buildRelatedHashtags(List<TextMatch> content) {
    return [
      for (final match in content)
        if (match.matcherType == HashtagMatcher) RelatedHashtag(value: match.text),
    ];
  }

  List<RelatedEvent> _buildRelatedEvents(PostEntity parentEntity) {
    final rootRelatedEvent = parentEntity.data.relatedEvents
        ?.firstWhereOrNull((relatedEvent) => relatedEvent.marker == RelatedEventMarker.root);
    return [
      if (rootRelatedEvent != null) rootRelatedEvent,
      RelatedEvent(
        eventId: parentEntity.id,
        pubkey: parentEntity.pubkey,
        marker: rootRelatedEvent != null ? RelatedEventMarker.reply : RelatedEventMarker.root,
      ),
    ];
  }

  List<RelatedPubkey> _buildRelatedPubkeys(PostEntity parentEntity) {
    return <RelatedPubkey>{
      RelatedPubkey(value: parentEntity.pubkey),
      ...parentEntity.data.relatedPubkeys ?? [],
    }.toList();
  }

  Future<(FileMetadata, MediaAttachment)> _uploadImage(String imageId) async {
    final assetEntity = await ref.read(assetEntityProvider(imageId).future);
    if (assetEntity == null) {
      throw AssetEntityNotFoundException();
    }

    final file = await assetEntity.file;

    if (file == null) {
      throw AssetEntityFileNotFoundException();
    }

    const maxDimension = 1024;
    final compressedImage = await ref.read(mediaCompressServiceProvider).compressImage(
          MediaFile(path: file.path),
          // Do not pass the second dimension to keep the aspect ratio
          width: assetEntity.width > assetEntity.height ? maxDimension : null,
          height: assetEntity.height > assetEntity.width ? maxDimension : null,
          quality: 70,
        );

    return ref.read(nostrUploadNotifierProvider.notifier).upload(compressedImage);
  }
}
