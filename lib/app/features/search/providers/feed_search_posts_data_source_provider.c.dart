// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/feed/providers/feed_posts_data_source_provider.c.dart';
import 'package:ion/app/features/ion_connect/model/action_source.dart';
import 'package:ion/app/features/ion_connect/model/search_extension.dart';
import 'package:ion/app/features/ion_connect/providers/entities_paged_data_provider.c.dart';
import 'package:ion/app/features/search/model/advanced_search_category.dart';
import 'package:ion/app/features/search/model/feed_search_source.dart';
import 'package:ion/app/features/search/providers/feed_search_filter_relays_provider.c.dart';
import 'package:ion/app/features/search/providers/feed_search_filters_provider.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'feed_search_posts_data_source_provider.c.g.dart';

@riverpod
List<EntitiesDataSource>? feedSearchPostsDataSource(
  Ref ref, {
  required String query,
  required AdvancedSearchCategory category,
}) {
  final filters = ref.watch(feedSearchFilterProvider);
  final filterRelays = ref.watch(feedSearchFilterRelaysProvider(filters.source)).valueOrNull;
  final currentPubkey = ref.watch(currentPubkeySelectorProvider);

  if (filterRelays != null && currentPubkey != null) {
    return [
      for (final entry in filterRelays.entries)
        // switch (filters.category) {
        //   FeedCategory.articles => buildArticlesDataSource(
        //       actionSource: ActionSourceRelayUrl(entry.key),
        //       authors: filters.filter == FeedFilter.following ? entry.value : null,
        //       currentPubkey: currentPubkey,
        //     ),
        //   FeedCategory.videos => buildVideosDataSource(
        //       actionSource: ActionSourceRelayUrl(entry.key),
        //       authors: filters.filter == FeedFilter.following ? entry.value : null,
        //       currentPubkey: currentPubkey,
        //     ),
        buildPostsDataSource(
          actionSource: ActionSourceRelayUrl(entry.key),
          authors: filters.source == FeedSearchSource.following ? entry.value : null,
          currentPubkey: currentPubkey,
          searchExtensions: [
            QuerySearchExtension(searchQuery: query),
          ],
        ),
      // },
    ];
  }
  return null;
}
