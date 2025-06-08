// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/feed/data/models/entities/event_count_result_data.c.dart';
import 'package:ion/app/features/feed/data/models/entities/reaction_data.c.dart';
import 'package:ion/app/features/ion_connect/data/models/event_reference.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_cache.c.dart';
import 'package:ion/app/features/optimistic_ui/providers/post_like_provider.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'likes_count_provider.c.g.dart';

@riverpod
int likesCount(Ref ref, EventReference eventReference) {
  final optimistic =
      ref.watch(postLikeWatchProvider(eventReference.toString())).valueOrNull?.likesCount;

  if (optimistic != null) return optimistic;

  final counterEntity = ref.watch(
    ionConnectCacheProvider.select(
      cacheSelector<EventCountResultEntity>(
        EventCountResultEntity.cacheKeyBuilder(
          key: eventReference.toString(),
          type: EventCountResultType.reactions,
        ),
      ),
    ),
  );

  if (counterEntity == null) return 0;

  final reactionsCount = counterEntity.data.content as Map<String, dynamic>;

  return (reactionsCount[ReactionEntity.likeSymbol] ?? 0) as int;
}
