// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/auth/providers/auth_provider.m.dart';
import 'package:ion/app/features/feed/data/models/entities/reaction_data.f.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.f.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_cache.r.dart';
import 'package:ion/app/features/optimistic_ui/features/likes/post_like_provider.r.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'like_reaction_provider.r.g.dart';

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
  final optimistic = ref.watch(postLikeWatchProvider(eventReference.toString())).valueOrNull;

  if (optimistic != null) {
    return optimistic.likedByMe;
  }

  return ref.watch(likeReactionProvider(eventReference)) != null;
}
