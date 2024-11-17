// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/feed/data/models/entities/related_event.dart';
import 'package:ion/app/features/feed/data/models/entities/related_pubkey.dart';
import 'package:ion/app/features/feed/data/models/post_data.dart';
import 'package:ion/app/features/nostr/model/event_reference.dart';
import 'package:ion/app/features/nostr/providers/nostr_entity_provider.dart';
import 'package:ion/app/features/nostr/providers/nostr_notifier.dart';
import 'package:ion/app/services/media_service/media_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'create_post_notifier.g.dart';

@riverpod
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
      //TODO:: upload media and add to event's mediaAttachment
      var data = PostData.fromRawContent(content);

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
          relatedEvents: [
            RelatedEvent(
              eventId: parentEvent.eventId,
              pubkey: parentEvent.pubkey,
              marker: RelatedEventMarker.root,
            ),
          ],
          // TODO:check
          relatedPubkeys: <RelatedPubkey>{
            RelatedPubkey(value: parentEvent.pubkey),
            ...parentEntity.data.relatedPubkeys ?? [],
          }.toList(),
        );
      }

      await ref.read(nostrNotifierProvider.notifier).sendEntityData(data);
    });
  }
}
