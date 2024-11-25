// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/features/feed/data/models/entities/reaction_data.dart';
import 'package:ion/app/features/feed/providers/counters/like_reaction_provider.dart';
import 'package:ion/app/features/nostr/model/deletion_request.dart';
import 'package:ion/app/features/nostr/model/event_reference.dart';
import 'package:ion/app/features/nostr/providers/nostr_cache.dart';
import 'package:ion/app/features/nostr/providers/nostr_notifier.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'likes_notifier.g.dart';

@riverpod
class LikesNotifier extends _$LikesNotifier {
  @override
  FutureOr<void> build(EventReference eventReference) {}

  Future<void> toggle() async {
    if (state.isLoading) {
      return;
    }

    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      final likeEntity = ref.read(likeReactionProvider(eventReference));

      if (likeEntity != null) {
        final data = DeletionRequest(
          events: [EventToDelete(eventId: likeEntity.id, kind: ReactionEntity.kind)],
        );
        final event = ref.read(nostrNotifierProvider.notifier).sign(data);
        await ref.read(nostrNotifierProvider.notifier).sendEvent(event);
        ref.read(nostrCacheProvider.notifier).remove(likeEntity.cacheKey);
      } else {
        final data = ReactionData(
          content: ReactionEntity.likeSymbol,
          eventId: eventReference.eventId,
          pubkey: eventReference.pubkey,
        );
        await ref.read(nostrNotifierProvider.notifier).sendEntityData(data);
      }
      //TODO::update counters with EventCountRequestData
    });
  }
}
