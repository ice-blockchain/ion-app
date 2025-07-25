// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/feed/providers/counters/helpers/counter_cache_helpers.r.dart';
import 'package:ion/app/features/feed/reposts/providers/optimistic/post_repost_provider.r.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.f.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'reposts_count_provider.r.g.dart';

@riverpod
int repostsCount(Ref ref, EventReference eventReference) {
  // First, always check cache for counter data
  final counts = ref.watch(repostCountsFromCacheProvider(eventReference));
  final cacheCount = counts.repostsCount + counts.quotesCount;

  // Then check optimistic UI for any pending operations
  final optimisticAsync = ref.watch(postRepostWatchProvider(eventReference.toString()));
  final optimisticData = optimisticAsync.valueOrNull;

  // If we have optimistic data, use it (it includes pending operations)
  if (optimisticData != null) {
    return optimisticData.totalRepostsCount;
  }

  // Otherwise, use cache count
  return cacheCount;
}
