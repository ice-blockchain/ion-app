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
    final repostsCount = _getCountFromCache(EventCountResultType.reposts);
    final quotesCount = _getCountFromCache(EventCountResultType.quotes);

    return repostsCount + quotesCount;
  }

  void addOne() {
    if (state != null) {
      state = state! + 1;
    }
  }

  void removeOne({bool isQuote = false}) {
    if (state == null) return;

    final countType = isQuote ? EventCountResultType.quotes : EventCountResultType.reposts;
    final count = _getCountFromCache(countType);

    if (count == 1) {
      _removeCacheEntry(countType);
    }

    if (state! > 0) {
      state = state! - 1;
    }
  }

  int _getCountFromCache(EventCountResultType type) {
    final entity = ref.read(
      ionConnectCacheProvider.select(
        cacheSelector<EventCountResultEntity>(
          _buildCacheKey(type),
        ),
      ),
    );

    return entity != null ? entity.data.content as int : 0;
  }

  String _buildCacheKey(EventCountResultType type) {
    return EventCountResultEntity.cacheKeyBuilder(
      key: eventReference.toString(),
      type: type,
    );
  }

  void _removeCacheEntry(EventCountResultType type) {
    // Manually remove the cache entry when counter reaches zero.
    // This is necessary because when the backend counter is 0, no event is sent to the frontend,
    // but the old value remains in the cache, causing stale data to be displayed.
    ref.read(ionConnectCacheProvider.notifier).remove(
          _buildCacheKey(type),
        );
  }
}
