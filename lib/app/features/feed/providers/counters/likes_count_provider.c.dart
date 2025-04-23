// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/features/feed/data/models/entities/event_count_result_data.c.dart';
import 'package:ion/app/features/feed/data/models/entities/reaction_data.c.dart';
import 'package:ion/app/features/feed/likes/providers/optimistic_likes_manager.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_cache.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'likes_count_provider.c.g.dart';

@riverpod
class LikesCount extends _$LikesCount {
  @override
  int build(EventReference eventReference) {
    final optimisticAsync = ref.watch(optimisticPostLikeStreamProvider(eventReference));
    final optimistic = optimisticAsync.maybeWhen(data: (data) => data, orElse: () => null);

    if (optimistic != null) {
      return optimistic.likesCount;
    }

    final reactionsCountEntity = ref.watch(
      ionConnectCacheProvider.select(
        cacheSelector<EventCountResultEntity>(
          EventCountResultEntity.cacheKeyBuilder(
            key: eventReference.toString(),
            type: EventCountResultType.reactions,
          ),
        ),
      ),
    );

    if (reactionsCountEntity == null) {
      return 0;
    }

    final content = reactionsCountEntity.data.content as Map<String, dynamic>;
    return (content[ReactionEntity.likeSymbol] ?? 0) as int;
  }

  void addOne() {
    state = state + 1;
  }

  void removeOne() {
    if (state > 1) {
      state = state - 1;
    } else if (state == 1) {
      ref.read(ionConnectCacheProvider.notifier).remove(
            EventCountResultEntity.cacheKeyBuilder(
              key: eventReference.toString(),
              type: EventCountResultType.reactions,
            ),
          );
    }
  }
}
