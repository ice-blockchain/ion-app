// SPDX-License-Identifier: ice License 1.0

import 'package:collection/collection.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/feed/data/models/entities/post_data.c.dart';
import 'package:ion/app/features/feed/data/models/entities/reaction_data.c.dart';
import 'package:ion/app/features/feed/likes/model/post_like.c.dart';
import 'package:ion/app/features/feed/providers/counters/like_reaction_provider.c.dart';
import 'package:ion/app/features/ion_connect/model/deletion_request.c.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_cache.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_notifier.c.dart';
import 'package:ion/app/features/optimistic_ui/operation_manager.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'optimistic_likes_manager.c.g.dart';

@riverpod
OptimisticOperationManager<PostLike> optimisticLikesManager(Ref ref) {
  final ionNotifier = ref.read(ionConnectNotifierProvider.notifier);

  final manager = OptimisticOperationManager<PostLike>(
    syncCallback: (previous, optimistic) async {
      final toggledToLike = optimistic.likedByMe && !previous.likedByMe;
      final toggledToUnlike = !optimistic.likedByMe && previous.likedByMe;

      if (toggledToLike) {
        final data = ReactionData(
          content: ReactionEntity.likeSymbol,
          eventReference: optimistic.eventReference,
          kind: optimistic.eventReference is ReplaceableEventReference
              ? (optimistic.eventReference as ReplaceableEventReference).kind
              : PostEntity.kind,
        );

        await ionNotifier.sendEntityData<ReactionEntity>(data);
      } else if (toggledToUnlike) {
        final likeEntity = ref.read(likeReactionProvider(optimistic.eventReference));

        if (likeEntity != null) {
          final deletion = DeletionRequest(
            events: [EventToDelete(eventId: likeEntity.id, kind: ReactionEntity.kind)],
          );

          await ionNotifier.sendEntityData(deletion, cache: false);
          ref.read(ionConnectCacheProvider.notifier).remove(likeEntity.cacheKey);
        }
      }

      return optimistic;
    },
    onError: (_, __) async => false,
  );

  ref.onDispose(manager.dispose);

  return manager;
}

/// Exposes a stream of [PostLike] for a specific [EventReference].
@riverpod
Stream<PostLike?> optimisticPostLikeStream(Ref ref, EventReference eventReference) async* {
  final manager = ref.watch(optimisticLikesManagerProvider);

  // Synchronous first value.
  yield manager.snapshot
      .firstWhereOrNull((PostLike e) => e.optimisticId == eventReference.toString());

  yield* manager.stream.map(
    (List<PostLike> list) =>
        list.firstWhereOrNull((PostLike e) => e.optimisticId == eventReference.toString()),
  );
}
