// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/feed/data/models/entities/post_data.c.dart';
import 'package:ion/app/features/feed/providers/replies_provider.c.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';
import 'package:ion/app/features/ion_connect/model/ion_connect_entity.dart';
import 'package:ion/app/features/ion_connect/model/related_event.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_cache.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'replied_events_provider.c.g.dart';

@Riverpod(keepAlive: true)
Stream<Map<String, List<String>>?> repliedEvents(Ref ref) async* {
  final currentPubkey = await ref.watch(currentPubkeySelectorProvider.future);

  if (currentPubkey == null) {
    yield {};
  } else {
    var repliedMap = <String, List<String>>{};

    final cache = ref.read(ionConnectCacheProvider);
    repliedMap = _buildInitialMap(cache, currentPubkey);
    yield repliedMap;

    await for (final entity in ref.watch(ionConnectCacheStreamProvider)) {
      if (entity case final PostEntity post) {
        final parentId = post.data.parentEvent?.eventId;
        if (parentId == null) {
          continue;
        }

        final currentCache = ref.read(ionConnectCacheProvider);
        final isInCache = currentCache.containsKey(post.id);

        if (!isInCache) {
          if (repliedMap.containsKey(post.id)) {
            repliedMap.remove(post.id);
          }

          if (repliedMap.containsKey(parentId)) {
            repliedMap[parentId] = repliedMap[parentId]!.where((id) => id != post.id).toList();
            if (repliedMap[parentId]!.isEmpty) {
              repliedMap.remove(parentId);
            }
          }

          yield repliedMap;
        } else {
          final currentUserRepliedIds =
              _getCurrentUserRepliedIds(post, currentPubkey: currentPubkey);

          if (currentUserRepliedIds != null) {
            repliedMap[parentId] = currentUserRepliedIds;

            yield repliedMap;
          }
        }
      }
    }
  }
}

Map<String, List<String>> _buildInitialMap(
  Map<String, CacheableEntity> cache,
  String currentPubkey,
) {
  return cache.values.fold<Map<String, List<String>>>({}, (result, entry) {
    if (entry case final PostEntity post) {
      final currentUserRepliedIds = _getCurrentUserRepliedIds(post, currentPubkey: currentPubkey);
      final parentId = post.data.parentEvent?.eventId;
      if (currentUserRepliedIds != null && parentId != null) {
        if (!result.containsKey(parentId)) {
          result[parentId] = [];
        }
        final newIds = currentUserRepliedIds.where((id) => !result[parentId]!.contains(id));
        result[parentId] = [...result[parentId]!, ...newIds];
      }
    }
    return result;
  });
}

List<String>? _getCurrentUserRepliedIds(IonConnectEntity entity, {required String currentPubkey}) {
  if (entity case final PostEntity post when post.masterPubkey == currentPubkey) {
    final relatedEvents = post.data.relatedEvents;

    if (relatedEvents == null) {
      return null;
    }

    final replyIds = [
      for (final event in relatedEvents)
        if (event.marker == RelatedEventMarker.reply || event.marker == RelatedEventMarker.root)
          event.eventId,
    ];
    return replyIds;
  }
  return null;
}

@riverpod
bool isReplied(Ref ref, EventReference eventReference) {
  final repliedMap = ref.watch(repliedEventsProvider).valueOrNull;
  final hasReply = repliedMap?[eventReference.eventId]?.isNotEmpty ?? false;

  final replies = ref.watch(repliesProvider(eventReference));
  final hasActiveReplies = replies?.data.items?.isNotEmpty ?? false;

  final isActive = hasReply && hasActiveReplies;

  return isActive;
}
