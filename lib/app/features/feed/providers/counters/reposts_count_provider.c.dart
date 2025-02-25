// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/features/feed/data/models/entities/event_count_result_data.c.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_cache.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'reposts_count_provider.c.g.dart';

@riverpod
class RepostsCount extends _$RepostsCount {
  @override
  int? build(EventReference eventReference) {
    final repostsCountEntity = ref.watch(
      ionConnectCacheProvider.select(
        cacheSelector<EventCountResultEntity>(
          EventCountResultEntity.cacheKeyBuilder(
            key: eventReference.toString(),
            type: EventCountResultType.reposts,
          ),
        ),
      ),
    );

    final quotesCountEntity = ref.watch(
      ionConnectCacheProvider.select(
        cacheSelector<EventCountResultEntity>(
          EventCountResultEntity.cacheKeyBuilder(
            key: eventReference.toString(),
            type: EventCountResultType.quotes,
          ),
        ),
      ),
    );

    final repostsCount = repostsCountEntity != null ? repostsCountEntity.data.content as int : 0;
    final quotesCount = quotesCountEntity != null ? quotesCountEntity.data.content as int : 0;

    return repostsCount + quotesCount;
  }

  void addOne() {
    if (state != null) {
      state = state! + 1;
      _updateCacheCount(state!);
    }
  }

  void removeOne() {
    if (state != null) {
      state = state! - 1;
      _updateCacheCount(state!);
    }
  }

  void _updateCacheCount(int newCount) {
    final repostsKey = EventCountResultEntity.cacheKeyBuilder(
      key: eventReference.toString(),
      type: EventCountResultType.reposts,
    );

    final repostsEntity = ref.read(ionConnectCacheProvider)[repostsKey];
    if (repostsEntity != null) {
      final updatedEntity = (repostsEntity.entity as EventCountResultEntity).copyWith(
        data: (repostsEntity.entity as EventCountResultEntity).data.copyWith(
              content: newCount,
            ),
      );

      final cache = ref.read(ionConnectCacheProvider.notifier);
      cache.cache(updatedEntity);
    }
  }
}
