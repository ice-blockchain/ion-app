// SPDX-License-Identifier: ice License 1.0

import 'package:collection/collection.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/feed/data/models/entities/reaction_data.c.dart';
import 'package:ion/app/features/feed/providers/counters/like_reaction_provider.c.dart';
import 'package:ion/app/features/feed/providers/counters/likes_count_provider.c.dart';
import 'package:ion/app/features/ion_connect/data/models/event_reference.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_cache.c.dart';
import 'package:ion/app/features/optimistic_ui/core/operation_manager.dart';
import 'package:ion/app/features/optimistic_ui/core/optimistic_service.dart';
import 'package:ion/app/features/optimistic_ui/features/likes/data/models/post_like.c.dart';
import 'package:ion/app/features/optimistic_ui/features/likes/toggle_like_intent.dart';
import 'package:ion/app/features/optimistic_ui/providers/like_sync_strategy_provider.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'post_like_provider.c.g.dart';

@riverpod
List<PostLike> loadInitialLikesFromCache(Ref ref) {
  final currentPubkey = ref.read(currentPubkeySelectorProvider);
  final reactions = ref
      .read(ionConnectCacheProvider)
      .values
      .map((e) => e.entity)
      .whereType<ReactionEntity>()
      .where((r) => r.data.content == ReactionEntity.likeSymbol)
      .toList();

  final grouped = groupBy<ReactionEntity, EventReference>(
    reactions,
    (r) => r.data.eventReference,
  );

  return grouped.entries.map((entry) {
    final eventRef = entry.key;
    final list = entry.value;
    final count = list.length;
    final likedByMe = currentPubkey != null && list.any((r) => r.pubkey == currentPubkey);
    return PostLike(
      eventReference: eventRef,
      likesCount: count,
      likedByMe: likedByMe,
    );
  }).toList();
}

@riverpod
OptimisticService<PostLike> postLikeService(Ref ref) {
  final manager = ref.watch(postLikeManagerProvider);
  final service = OptimisticService<PostLike>(manager: manager)
    ..initialize(loadInitialLikesFromCache(ref));

  return service;
}

@riverpod
Stream<PostLike?> postLikeWatch(Ref ref, String id) {
  final service = ref.watch(postLikeServiceProvider);
  return service.watch(id);
}

@Riverpod(keepAlive: true)
OptimisticOperationManager<PostLike> postLikeManager(Ref ref) {
  final strategy = ref.watch(likeSyncStrategyProvider);

  final manager = OptimisticOperationManager<PostLike>(
    syncCallback: strategy.send,
    onError: (_, __) async => true,
  );

  ref.onDispose(manager.dispose);

  return manager;
}

@riverpod
class ToggleLikeNotifier extends _$ToggleLikeNotifier {
  @override
  void build() {}

  Future<void> toggle(EventReference eventReference) async {
    final service = ref.read(postLikeServiceProvider);
    final id = eventReference.toString();

    var current = ref.read(postLikeWatchProvider(id)).valueOrNull;

    current ??= PostLike(
      eventReference: eventReference,
      likesCount: ref.read(likesCountProvider(eventReference)),
      likedByMe: ref.read(isLikedProvider(eventReference)),
    );

    await service.dispatch(ToggleLikeIntent(), current);
  }
}
