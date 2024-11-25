// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/auth/providers/auth_provider.dart';
import 'package:ion/app/features/feed/data/models/entities/post_data.dart';
import 'package:ion/app/features/feed/data/models/entities/related_event.dart';
import 'package:ion/app/features/nostr/model/event_reference.dart';
import 'package:ion/app/features/nostr/model/nostr_entity.dart';
import 'package:ion/app/features/nostr/providers/nostr_cache.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'replied_events_provider.g.dart';

@Riverpod(keepAlive: true)
Stream<Set<String>?> repliedEvents(Ref ref) async* {
  final currentPubkey = ref.watch(currentPubkeySelectorProvider);

  if (currentPubkey == null) {
    yield {};
  } else {
    final cache = ref.read(nostrCacheProvider);
    var repliedIds = cache.values.fold<Set<String>>({}, (result, entity) {
      final repliedId = _getCurrentUserRepliedId(entity, currentPubkey: currentPubkey);
      if (repliedId != null) {
        result.add(repliedId);
      }
      return result;
    });

    yield repliedIds;

    await for (final entity in ref.watch(nostrCacheStreamProvider)) {
      final repliedId = _getCurrentUserRepliedId(entity, currentPubkey: currentPubkey);
      if (repliedId != null) {
        yield repliedIds = {...repliedIds, repliedId};
      }
    }
  }
}

String? _getCurrentUserRepliedId(NostrEntity entity, {required String currentPubkey}) {
  if (entity.pubkey != currentPubkey) {
    return null;
  }

  if (entity is PostEntity && entity.data.relatedEvents != null) {
    String? rootReplyId;
    String? replyId;
    for (final relatedEvent in entity.data.relatedEvents!) {
      if (relatedEvent.marker == RelatedEventMarker.reply) {
        replyId = relatedEvent.eventId;
      } else if (relatedEvent.marker == RelatedEventMarker.root) {
        rootReplyId = relatedEvent.eventId;
      }
    }
    return replyId ?? rootReplyId;
  } else {
    return null;
  }
}

@riverpod
bool isReplied(Ref ref, EventReference eventReference) {
  return ref.watch(repliedEventsProvider).valueOrNull?.contains(eventReference.eventId) ?? false;
}
