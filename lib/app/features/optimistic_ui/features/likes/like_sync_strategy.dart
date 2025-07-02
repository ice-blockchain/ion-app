// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/features/feed/data/models/entities/event_count_result_data.f.dart';
import 'package:ion/app/features/feed/data/models/entities/post_data.f.dart';
import 'package:ion/app/features/feed/data/models/entities/reaction_data.f.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.f.dart';
import 'package:ion/app/features/optimistic_ui/core/optimistic_sync_strategy.dart';
import 'package:ion/app/features/optimistic_ui/features/likes/model/post_like.f.dart';

/// Sync strategy for toggling likes using IonConnectNotifier.
class LikeSyncStrategy implements SyncStrategy<PostLike> {
  LikeSyncStrategy({
    required this.sendReaction,
    required this.getLikeEntity,
    required this.deleteReaction,
    required this.removeFromCache,
  });

  final Future<void> Function(ReactionData) sendReaction;
  final ReactionEntity? Function(EventReference) getLikeEntity;
  final Future<void> Function(ReactionEntity) deleteReaction;
  final void Function(String) removeFromCache;

  @override
  Future<PostLike> send(PostLike previous, PostLike optimistic) async {
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
      await sendReaction(data);
    } else if (toggledToUnlike) {
      final likeEntity = getLikeEntity(optimistic.eventReference);
      if (likeEntity != null && likeEntity.id.isNotEmpty) {
        await deleteReaction(likeEntity);
        removeFromCache(likeEntity.cacheKey);
        if (optimistic.likesCount == 0) {
          removeFromCache(
            EventCountResultEntity.cacheKeyBuilder(
              key: optimistic.eventReference.toString(),
              type: EventCountResultType.reactions,
            ),
          );
        }
      }
    }
    return optimistic;
  }
}
