// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/screen_offset/screen_top_offset.dart';
import 'package:ion/app/features/feed/feed_search/providers/feed_search_history_provider.dart'
    show feedSearchHistoryProvider;
import 'package:ion/app/features/feed/feed_search/providers/feed_search_users_provider.dart';
import 'package:ion/app/features/feed/feed_search/views/components/nothing_is_found.dart';
import 'package:ion/app/features/feed/feed_search/views/pages/feed_simple_search_page/components/feed_search_history/feed_search_history.dart';
import 'package:ion/app/features/feed/feed_search/views/pages/feed_simple_search_page/components/feed_search_history_empty/feed_search_history_empty.dart';
import 'package:ion/app/features/feed/feed_search/views/pages/feed_simple_search_page/components/feed_search_navigation/feed_search_navigation.dart';
import 'package:ion/app/features/feed/feed_search/views/pages/feed_simple_search_page/components/feed_search_results/feed_search_results.dart';
import 'package:ion/app/features/feed/feed_search/views/pages/feed_simple_search_page/components/feed_search_results/feed_search_results_skeleton.dart';

class FeedSimpleSearchPage extends ConsumerWidget {
  const FeedSimpleSearchPage({required this.query, super.key});

  final String query;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final history = ref.watch(feedSearchHistoryProvider);
    final usersSearchResults = ref.watch(feedSearchUsersProvider(query));

    return Scaffold(
      body: ScreenTopOffset(
        child: Column(
          children: [
            FeedSearchNavigation(query: query, loading: usersSearchResults.isLoading),
            usersSearchResults.maybeWhen(
              data: (userIds) => userIds == null
                  ? history.userIds.isEmpty && history.queries.isEmpty
                      ? const FeedSearchHistoryEmpty()
                      : FeedSearchHistory(userIds: history.userIds, queries: history.queries)
                  : userIds.isEmpty
                      ? const NothingIsFound()
                      : FeedSearchResults(userIds: userIds),
              orElse: FeedSearchResultsSkeleton.new,
            ),
          ],
        ),
      ),
    );
  }
}
