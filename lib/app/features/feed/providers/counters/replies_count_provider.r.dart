// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/features/feed/data/models/entities/event_count_result_data.f.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.f.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_cache.r.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'replies_count_provider.r.g.dart';

@riverpod
class RepliesCount extends _$RepliesCount {
  @override
  int build(EventReference eventReference) {
    final cacheCount = ref
            .watch(
              ionConnectCacheProvider.select(
                cacheSelector<EventCountResultEntity>(
                  EventCountResultEntity.cacheKeyBuilder(
                    key: eventReference.toString(),
                    type: EventCountResultType.replies,
                  ),
                ),
              ),
            )
            ?.data
            .content as int? ??
        0;

    return cacheCount;
  }

  void addOne() {
    state = state + 1;
    _updateCache(eventReference, state);
  }

  void removeOne() {
    state = state - 1;
    _updateCache(eventReference, state);
  }

  void _updateCache(EventReference eventReference, int newCount) {
    final cacheKey = EventCountResultEntity.cacheKeyBuilder(
      key: eventReference.toString(),
      type: EventCountResultType.replies,
    );

    final cacheEntry =
        ref.read(ionConnectCacheProvider.select(cacheSelector<EventCountResultEntity>(cacheKey)));

    if (cacheEntry == null) {
      return;
    }

    ref.read(ionConnectCacheProvider.notifier).cache(
          cacheEntry.copyWith(data: cacheEntry.data.copyWith(content: newCount)),
        );
  }
}
