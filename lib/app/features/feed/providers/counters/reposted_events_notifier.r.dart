// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/auth/providers/auth_provider.m.dart';
import 'package:ion/app/features/feed/data/models/entities/generic_repost.f.dart';
import 'package:ion/app/features/feed/data/models/entities/repost_data.f.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.f.dart';
import 'package:ion/app/features/ion_connect/model/ion_connect_entity.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_cache.r.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'reposted_events_notifier.r.g.dart';

@Riverpod(keepAlive: true)
class RepostedEventsNotifier extends _$RepostedEventsNotifier {
  @override
  Map<EventReference, EventReference> build() {
    final currentPubkey = ref.watch(currentPubkeySelectorProvider);

    if (currentPubkey == null) {
      return {};
    }

    final cache = ref.read(ionConnectCacheProvider);
    final repostedMap = cache.values.fold<Map<EventReference, EventReference>>({}, (result, entry) {
      final userRepostData = _getCurrentUserRepostData(entry.entity, currentPubkey: currentPubkey);
      if (userRepostData != null) {
        result[userRepostData.postReference] = userRepostData.repostReference;
      }
      return result;
    });

    final subscription = ref.watch(ionConnectCacheStreamProvider).listen((entity) {
      final userRepostData = _getCurrentUserRepostData(entity, currentPubkey: currentPubkey);
      if (userRepostData != null) {
        state = {
          ...state,
          userRepostData.postReference: userRepostData.repostReference,
        };
      }
    });

    ref.onDispose(() async {
      await subscription.cancel();
    });

    return repostedMap;
  }

  void removeRepost(EventReference eventReference) {
    if (state.containsKey(eventReference)) {
      final newState = Map<EventReference, EventReference>.from(state)..remove(eventReference);
      state = newState;
    }
  }

  ({EventReference repostReference, EventReference postReference})? _getCurrentUserRepostData(
    IonConnectEntity entity, {
    required String currentPubkey,
  }) {
    if (entity.masterPubkey != currentPubkey) {
      return null;
    }

    return switch (entity) {
      GenericRepostEntity() => (
          repostReference: entity.toEventReference(),
          postReference: entity.data.eventReference,
        ),
      RepostEntity() => (
          repostReference: entity.toEventReference(),
          postReference: entity.data.eventReference,
        ),
      _ => null,
    };
  }
}

@riverpod
bool isReposted(Ref ref, EventReference eventReference) {
  return ref.watch(repostReferenceProvider(eventReference)) != null;
}

@riverpod
EventReference? repostReference(Ref ref, EventReference eventReference) {
  final repostedMap = ref.watch(repostedEventsNotifierProvider);
  return repostedMap[eventReference];
}
