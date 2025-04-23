// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/feed/data/models/entities/reaction_data.c.dart';
import 'package:ion/app/features/feed/likes/providers/optimistic_likes_manager.c.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_cache.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'like_reaction_provider.c.g.dart';

@riverpod
ReactionEntity? likeReaction(Ref ref, EventReference eventReference) {
  final currentPubkey = ref.watch(currentPubkeySelectorProvider);

  if (currentPubkey == null) {
    return null;
  }

  final reactionEntity = ref.watch(
    ionConnectCacheProvider.select(
      cacheSelector<ReactionEntity>(
        ReactionEntity.cacheKeyBuilder(
          eventReference: eventReference,
          content: ReactionEntity.likeSymbol,
        ),
      ),
    ),
  );

  return reactionEntity;
}

@riverpod
bool isLiked(Ref ref, EventReference eventReference) {
  final optimisticAsync = ref.watch(optimisticPostLikeStreamProvider(eventReference));
  final optimistic = optimisticAsync.maybeWhen(data: (postLike) => postLike, orElse: () => null);
  if (optimistic != null) return optimistic.likedByMe;

  return ref.watch(likeReactionProvider(eventReference)) != null;
}
