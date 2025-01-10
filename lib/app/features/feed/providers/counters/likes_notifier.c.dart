// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/features/feed/data/models/entities/reaction_data.c.dart';
import 'package:ion/app/features/feed/providers/counters/like_reaction_provider.c.dart';
import 'package:ion/app/features/feed/providers/counters/likes_count_provider.c.dart';
import 'package:ion/app/features/ion_connect/model/deletion_request.c.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_cache.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_notifier.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'likes_notifier.c.g.dart';

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
        await ref.read(ionConnectNotifierProvider.notifier).sendEntityData(data, cache: false);
        ref.read(ionConnectCacheProvider.notifier).remove(likeEntity.cacheKey);
        ref.read(likesCountProvider(eventReference).notifier).removeOne();
      } else {
        final data = ReactionData(
          content: ReactionEntity.likeSymbol,
          eventId: eventReference.eventId,
          pubkey: eventReference.pubkey,
        );
        await ref.read(ionConnectNotifierProvider.notifier).sendEntityData(data);
        ref.read(likesCountProvider(eventReference).notifier).addOne();
      }
    });
  }
}
