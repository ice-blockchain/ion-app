// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/feed/data/models/entities/post_data.dart';
import 'package:ion/app/features/feed/data/models/feed_filter.dart';
import 'package:ion/app/features/feed/providers/feed_current_filter_provider.dart';
import 'package:ion/app/features/feed/providers/feed_filter_relays_provider.dart';
import 'package:ion/app/features/nostr/model/action_source.dart';
import 'package:ion/app/features/nostr/providers/entities_paged_data_provider.dart';
import 'package:nostr_dart/nostr_dart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'feed_trending_videos_data_source_provider.g.dart';

@riverpod
List<EntitiesDataSource>? feedTrendingVideosDataSource(Ref ref) {
  final filters = ref.watch(feedCurrentFilterProvider.select((state) => state.filter));
  final filterRelays = ref.watch(feedFilterRelaysProvider(filters)).valueOrNull;

  if (filterRelays != null) {
    final dataSources = [
      for (final entry in filterRelays.entries)
        EntitiesDataSource(
          actionSource: ActionSourceRelayUrl(entry.key),
          entityFilter: (entity) => entity is PostEntity,
          requestFilters: [
            RequestFilter(
              kinds: const [PostEntity.kind],
              authors: filters == FeedFilter.following ? entry.value : null,
              limit: 10,
            ),
          ],
        ),
    ];

    return dataSources;
  }
  return null;
}
