// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/feed/providers/counters/helpers/counter_cache_helpers.r.dart';
import 'package:ion/app/features/feed/reposts/providers/optimistic/post_repost_provider.r.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.f.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'reposts_count_provider.r.g.dart';

@riverpod
int repostsCount(Ref ref, EventReference eventReference) {
  final optimistic =
      ref.watch(postRepostWatchProvider(eventReference.toString())).valueOrNull?.totalRepostsCount;

  if (optimistic != null) {
    return optimistic;
  }

  final counts = ref.watch(repostCountsFromCacheProvider(eventReference));
  final totalCount = counts.repostsCount + counts.quotesCount;
  
  return totalCount;
}
