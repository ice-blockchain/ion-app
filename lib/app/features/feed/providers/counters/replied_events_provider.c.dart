// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/feed/data/models/entities/modifiable_post_data.c.dart';
import 'package:ion/app/features/ion_connect/data/models/event_reference.c.dart';
import 'package:ion/app/features/ion_connect/data/models/ion_connect_entity.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_cache.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'replied_events_provider.c.g.dart';

@Riverpod(keepAlive: true)
class RepliedEvents extends _$RepliedEvents {
  final _deletedIds = <String>{};

  @override
  Stream<Map<String, List<String>>?> build() async* {
    final currentPubkey = ref.watch(currentPubkeySelectorProvider);

    if (currentPubkey == null) {
      yield {};
      return;
    }

    final cache = ref.read(ionConnectCacheProvider);
    var repliedMap = _buildInitialMap(cache, currentPubkey);

    yield repliedMap;

    final controller = StreamController<Map<String, List<String>>>();

    final subscription = ref.watch(ionConnectCacheStreamProvider).listen((entity) {
      if (entity case final ModifiablePostEntity post) {
        final parentId = post.data.parentEvent?.eventReference.toString();
        if (parentId == null) return;

        final currentUserRepliedIds = _getCurrentUserRepliedIds(post, currentPubkey: currentPubkey);

        if (currentUserRepliedIds != null) {
          final validIds = currentUserRepliedIds.where((id) => !_deletedIds.contains(id)).toList();

          final updatedMap = Map<String, List<String>>.from(repliedMap);

          if (validIds.isEmpty) {
            updatedMap.remove(parentId);
          } else {
            updatedMap[parentId] = validIds;
          }

          repliedMap = updatedMap;
          controller.add(updatedMap);
        }
      }
    });

    ref.onDispose(() async {
      await subscription.cancel();
      await controller.close();
    });

    await for (final update in controller.stream) {
      yield update;
    }
  }

  void removeReply(String parentId, String replyId) {
    _deletedIds.add(replyId);

    final currentMap = state.valueOrNull;
    if (currentMap != null && currentMap.containsKey(parentId)) {
      final updatedReplies = Map<String, List<String>>.from(currentMap);
      updatedReplies[parentId] = updatedReplies[parentId]!.where((id) => id != replyId).toList();

      if (updatedReplies[parentId]!.isEmpty) {
        updatedReplies.remove(parentId);
      }

      state = AsyncData(updatedReplies);
    }
  }
}

Map<String, List<String>> _buildInitialMap(
  Map<String, CacheEntry> cache,
  String currentPubkey,
) {
  return cache.values.fold<Map<String, List<String>>>({}, (result, entry) {
    if (entry.entity case final ModifiablePostEntity post) {
      final currentUserRepliedIds = _getCurrentUserRepliedIds(post, currentPubkey: currentPubkey);
      final parentId = post.data.parentEvent?.eventReference.toString();
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
  if (entity case final ModifiablePostEntity post when post.masterPubkey == currentPubkey) {
    if (post.data.parentEvent != null) {
      return [post.id];
    }
  }
  return null;
}

@riverpod
bool isReplied(Ref ref, EventReference eventReference) {
  final repliedMap = ref.watch(repliedEventsProvider).valueOrNull;
  final replyIds = repliedMap?[eventReference.toString()];

  final deletedIds = ref.read(repliedEventsProvider.notifier)._deletedIds;
  final validReplyIds = replyIds?.where((id) => !deletedIds.contains(id)).toList();
  final hasReply = validReplyIds?.isNotEmpty ?? false;

  return hasReply;
}
