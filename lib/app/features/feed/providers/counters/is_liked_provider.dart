import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/auth/providers/auth_provider.dart';
import 'package:ion/app/features/feed/data/models/entities/reaction_data.dart';
import 'package:ion/app/features/nostr/model/event_reference.dart';
import 'package:ion/app/features/nostr/providers/nostr_cache.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'is_liked_provider.g.dart';

@riverpod
bool isLiked(Ref ref, EventReference eventReference) {
  final currentPubkey = ref.watch(currentPubkeySelectorProvider);

  if (currentPubkey == null) {
    return false;
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

  return reactionEntity != null;
}
