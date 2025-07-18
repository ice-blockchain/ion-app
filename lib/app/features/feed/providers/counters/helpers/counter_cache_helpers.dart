// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/feed/data/models/entities/event_count_result_data.f.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.f.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_cache.r.dart';

/// Gets count from cache for a specific event and type
int getCountFromCache(
  Ref ref,
  EventReference eventReference,
  EventCountResultType type,
) {
  final cacheKey = EventCountResultEntity.cacheKeyBuilder(
    key: eventReference.toString(),
    type: type,
  );

  final entity = ref.read(
    ionConnectCacheProvider.select(
      cacheSelector<EventCountResultEntity>(cacheKey),
    ),
  );

  final count = entity != null ? entity.data.content as int : 0;
  return count;
}

/// Gets both reposts and quotes counts from cache
({int repostsCount, int quotesCount}) getRepostCountsFromCache(
  Ref ref,
  EventReference eventReference,
) {
  return (
    repostsCount: getCountFromCache(ref, eventReference, EventCountResultType.reposts),
    quotesCount: getCountFromCache(ref, eventReference, EventCountResultType.quotes),
  );
}
