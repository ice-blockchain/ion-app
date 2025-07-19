// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/feed/data/models/entities/event_count_result_data.f.dart';
import 'package:ion/app/features/feed/reposts/models/post_repost.f.dart';
import 'package:ion/app/features/feed/reposts/providers/optimistic/intents/add_quote_intent.dart';
import 'package:ion/app/features/feed/reposts/providers/optimistic/intents/remove_quote_intent.dart';
import 'package:ion/app/features/feed/reposts/providers/optimistic/post_repost_provider.r.dart';
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

/// Invalidates repost and quote counters cache for a specific event
void invalidateRepostCounterCache(Ref ref, EventReference eventReference) {
  final cacheNotifier = ref.read(ionConnectCacheProvider.notifier);
  final repostsCacheKey = EventCountResultEntity.cacheKeyBuilder(
    key: eventReference.toString(),
    type: EventCountResultType.reposts,
  );
  final quotesCacheKey = EventCountResultEntity.cacheKeyBuilder(
    key: eventReference.toString(),
    type: EventCountResultType.quotes,
  );

  cacheNotifier
    ..remove(repostsCacheKey)
    ..remove(quotesCacheKey);
}

/// Updates quote counter for an event using optimistic UI
Future<void> updateQuoteCounter(
  Ref ref,
  EventReference quotedEvent, {
  required bool isAdding,
}) async {
  final service = ref.read(postRepostServiceProvider);
  final id = quotedEvent.toString();

  var current = ref.read(postRepostWatchProvider(id)).valueOrNull;
  if (current == null) {
    final cached = ref.read(findRepostInCacheProvider(quotedEvent));
    if (cached != null) {
      current = cached;
    } else {
      final counts = getRepostCountsFromCache(ref, quotedEvent);
      current = PostRepost(
        eventReference: quotedEvent,
        repostsCount: counts.repostsCount,
        quotesCount: counts.quotesCount,
        repostedByMe: false,
      );
    }
  }

  final intent = isAdding ? const AddQuoteIntent() : const RemoveQuoteIntent();
  await service.dispatch(intent, current);

  invalidateRepostCounterCache(ref, quotedEvent);
}
