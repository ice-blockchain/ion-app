// SPDX-License-Identifier: ice License 1.0

import 'dart:async';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/feed/data/models/entities/modifiable_post_data.c.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_cache.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'replied_events_provider.c.g.dart';

@riverpod
class RepliedEvents extends _$RepliedEvents {
  @override
  Stream<Map<String, List<String>>> build() async* {
    keepAliveWhenAuthenticated(ref);

    final currentMasterPubkey = ref.watch(currentPubkeySelectorProvider);

    if (currentMasterPubkey == null) {
      yield const {};
      return;
    }

    final cache = ref.watch(ionConnectCacheProvider);
    var repliesForEventsMap = _buildInitialMap(cache, currentMasterPubkey);

    yield Map.unmodifiable(repliesForEventsMap);

    // Filter the stream to only include relevant entities
    final filteredStream = ref.watch(ionConnectCacheStreamProvider)
      .where((entity) => 
        entity is ModifiablePostEntity && 
        entity.data.parentEvent != null && 
        entity.masterPubkey == currentMasterPubkey);

    await for (final entity in filteredStream) {
      final modifiablePost = entity as ModifiablePostEntity;
      final parentId = modifiablePost.data.parentEvent!.eventReference.toString();
      final updatedList = List<String>.from(repliesForEventsMap[parentId] ?? []);

      if (modifiablePost.isDeleted) {
        if (updatedList.remove(modifiablePost.id)) {
          repliesForEventsMap = Map<String, List<String>>.from(repliesForEventsMap)
            ..[parentId] = updatedList;
          yield Map.unmodifiable(repliesForEventsMap);
        }
      } else if (!updatedList.contains(modifiablePost.id)) {
        updatedList.add(modifiablePost.id);
        repliesForEventsMap = Map<String, List<String>>.from(repliesForEventsMap)
          ..[parentId] = updatedList;
        yield Map.unmodifiable(repliesForEventsMap);
      }
    }
  }
}

Map<String, List<String>> _buildInitialMap(
  Map<String, CacheEntry> cache,
  String currentUserMasterPubkey,
) {
  final result = <String, List<String>>{};

  for (final entry in cache.values) {
    final entity = entry.entity;
    if (entity is! ModifiablePostEntity ||
        entity.isDeleted ||
        entity.data.parentEvent == null ||
        entity.masterPubkey != currentUserMasterPubkey) {
      continue;
    }

    final parentId = entity.data.parentEvent!.eventReference.toString();
    result.putIfAbsent(parentId, () => []);
    if (!result[parentId]!.contains(entity.id)) {
      result[parentId]!.add(entity.id);
    }
  }

  return result;
}

@riverpod
bool isReplied(Ref ref, EventReference eventReference) {
  final eventReferenceString = eventReference.toString();
  
  // Use select to only listen for changes to the specific event reference
  return ref.watch(
    repliedEventsProvider.select(
      (asyncValue) => asyncValue.valueOrNull?[eventReferenceString]?.isNotEmpty ?? false,
    ),
  );
}
