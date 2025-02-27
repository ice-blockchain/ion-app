// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/features/feed/data/models/entities/event_count_result_data.c.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_cache.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'replies_count_provider.c.g.dart';

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
  }

  void removeOne() {
    if (state > 1) {
      state = state - 1;
    } else if (state == 1) {
      ref.read(ionConnectCacheProvider.notifier).remove(
            EventCountResultEntity.cacheKeyBuilder(
              key: eventReference.toString(),
              type: EventCountResultType.replies,
            ),
          );
    }
  }
}
