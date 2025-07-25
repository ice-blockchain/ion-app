// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/feed/providers/counters/like_reaction_provider.r.dart';
import 'package:ion/app/features/feed/providers/delete_entity_provider.r.dart';
import 'package:ion/app/features/ion_connect/model/action_source.f.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_cache.r.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_notifier.r.dart';
import 'package:ion/app/features/optimistic_ui/core/optimistic_sync_strategy.dart';
import 'package:ion/app/features/optimistic_ui/features/likes/like_sync_strategy.dart';
import 'package:ion/app/features/optimistic_ui/features/likes/model/post_like.f.dart';
import 'package:ion/app/features/user/providers/user_events_metadata_provider.r.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'like_sync_strategy_provider.r.g.dart';

@riverpod
SyncStrategy<PostLike> likeSyncStrategy(Ref ref) {
  final ionNotifier = ref.read(ionConnectNotifierProvider.notifier);

  return LikeSyncStrategy(
    sendReaction: (reaction) async {
      final reactionEvent = await ionNotifier.sign(reaction);
      final userEventsMetadataBuilder = await ref.read(userEventsMetadataBuilderProvider.future);
      await Future.wait([
        ionNotifier.sendEvent(reactionEvent),
        ionNotifier.sendEvent(
          reactionEvent,
          actionSource: ActionSourceUser(reaction.eventReference.masterPubkey),
          metadataBuilders: [userEventsMetadataBuilder],
          cache: false,
        ),
      ]);
    },
    getLikeEntity: (eventReference) => ref.read(likeReactionProvider(eventReference)),
    deleteReaction: (reactionEntity) async {
      await ref.read(deleteEntityControllerProvider.notifier).deleteEntity(reactionEntity);
    },
    removeFromCache: (cacheKey) => ref.read(ionConnectCacheProvider.notifier).remove(cacheKey),
  );
}
