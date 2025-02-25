// SPDX-License-Identifier: ice License 1.0

import 'package:collection/collection.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/feed/data/models/entities/modifiable_post_data.c.dart';
import 'package:ion/app/features/feed/data/models/entities/repost_data.c.dart';
import 'package:ion/app/features/feed/data/models/generic_repost.c.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';
import 'package:ion/app/features/ion_connect/model/ion_connect_entity.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_cache.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'reposted_events_provider.c.g.dart';

@Riverpod(keepAlive: true)
Stream<Map<String, String>?> repostedEvents(Ref ref) async* {
  final currentPubkey = ref.watch(currentPubkeySelectorProvider);

  if (currentPubkey == null) {
    yield {};
  } else {
    final cache = ref.read(ionConnectCacheProvider);
    var repostedMap = cache.values.fold<Map<String, String>>({}, (result, entry) {
      final (repostId, originalId) =
          _getCurrentUserRepostData(entry.entity, currentPubkey: currentPubkey);
      if (repostId != null && originalId != null) {
        result[originalId] = repostId;
      }
      return result;
    });

    yield repostedMap;

    await for (final entity in ref.watch(ionConnectCacheStreamProvider)) {
      final entryToRemove =
          repostedMap.entries.firstWhereOrNull((entry) => entry.value == entity.id);

      final cacheEntry = ref.read(ionConnectCacheProvider)[entity.id];

      if (entryToRemove != null && cacheEntry == null) {
        repostedMap = Map.from(repostedMap)..remove(entryToRemove.key);
        yield repostedMap;
        continue;
      }

      final (repostId, originalId) =
          _getCurrentUserRepostData(entity, currentPubkey: currentPubkey);

      if (repostId != null && originalId != null) {
        yield repostedMap = {...repostedMap, originalId: repostId};
      }
    }
  }
}

(String?, String?) _getCurrentUserRepostData(
  IonConnectEntity entity, {
  required String currentPubkey,
}) {
  if (entity.masterPubkey != currentPubkey) {
    return (null, null);
  }

  return switch (entity) {
    ModifiablePostEntity() when entity.data.quotedEvent != null => (
        entity.id,
        entity.data.quotedEvent!.eventReference.toString(),
      ),
    GenericRepostEntity() => (
        entity.id,
        entity.data.eventReference.toString(),
      ),
    RepostEntity() => (
        entity.id,
        entity.data.eventReference.toString(),
      ),
    _ => (null, null),
  };
}

@riverpod
bool isReposted(Ref ref, EventReference eventReference) {
  return ref.watch(repostReferenceProvider(eventReference)) != null;
}

@riverpod
EventReference? repostReference(Ref ref, EventReference eventReference) {
  final repostedMap = ref.watch(repostedEventsProvider).valueOrNull;
  final currentPubkey = ref.watch(currentPubkeySelectorProvider);
  final repostId = repostedMap?[eventReference.toString()];

  if (repostId != null) {
    final cacheEntry = ref.read(ionConnectCacheProvider)[repostId];
    if (cacheEntry == null) return null;

    final entity = cacheEntry.entity;
    if (entity.masterPubkey == currentPubkey) {
      return entity.toEventReference();
    }
  }
  return null;
}
