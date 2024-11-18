// SPDX-License-Identifier: ice License 1.0

import 'package:collection/collection.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/feed/data/models/entities/related_event.dart';
import 'package:ion/app/features/feed/data/models/entities/related_hashtag.dart';
import 'package:ion/app/features/feed/data/models/entities/related_pubkey.dart';
import 'package:ion/app/features/feed/data/models/post_data.dart';
import 'package:ion/app/features/nostr/model/event_reference.dart';
import 'package:ion/app/features/nostr/providers/nostr_entity_provider.dart';
import 'package:ion/app/features/nostr/providers/nostr_notifier.dart';
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
    List<MediaFile>? media,
  }) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      //TODO:upload media and add to event's mediaAttachment
      var data = PostData.fromRawContent(content);

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

      await ref.read(nostrNotifierProvider.notifier).sendEntityData(data);
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
}
