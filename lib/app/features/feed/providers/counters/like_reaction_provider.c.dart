// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/feed/data/models/entities/reaction_data.c.dart';
import 'package:ion/app/features/nostr/model/event_reference.c.dart';
import 'package:ion/app/features/nostr/providers/nostr_cache.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'like_reaction_provider.c.g.dart';

@riverpod
ReactionEntity? likeReaction(Ref ref, EventReference eventReference) {
  final currentPubkey = ref.watch(currentPubkeySelectorProvider).valueOrNull;

  if (currentPubkey == null) {
    return null;
  }

  final reactionEntity = ref.watch(
    nostrCacheProvider.select(
      cacheSelector<ReactionEntity>(
        ReactionEntity.cacheKeyBuilder(
          eventId: eventReference.eventId,
          pubkey: currentPubkey,
          content: ReactionEntity.likeSymbol,
        ),
      ),
    ),
  );

  return reactionEntity;
}

@riverpod
bool isLiked(Ref ref, EventReference eventReference) {
  return ref.watch(likeReactionProvider(eventReference)) != null;
}
