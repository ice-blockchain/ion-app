import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/screen_offset/screen_top_offset.dart';
import 'package:ice/app/features/feed/feed_search/providers/feed_search_history_store_provider.dart';
import 'package:ice/app/features/feed/feed_search/providers/feed_simple_search_results_provider.dart';
import 'package:ice/app/features/feed/feed_search/views/pages/feed_simple_search_page/components/feed_search_history_empty/feed_search_history_empty.dart';
import 'package:ice/app/features/feed/feed_search/views/pages/feed_simple_search_page/components/feed_search_navigation/feed_search_navigation.dart';
import 'package:ice/app/features/feed/feed_search/views/pages/feed_simple_search_page/components/feed_search_results/feed_search_results.dart';
import 'package:ice/app/features/feed/feed_search/views/pages/feed_simple_search_page/components/feed_search_history/feed_search_history.dart';
import 'package:ice/app/features/feed/feed_search/views/pages/feed_simple_search_page/components/feed_search_results/feed_search_results_skeleton.dart';

class FeedSimpleSearchPage extends ConsumerWidget {
  const FeedSimpleSearchPage({super.key, required this.query});

  final String query;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final history = ref.watch(feedSearchHistoryStoreProvider);
    final searchResults = ref.watch(feedSimpleSearchResultsProvider(query));

    return Scaffold(
      body: ScreenTopOffset(
        child: Column(
          children: [
            FeedSearchNavigation(query: query, loading: searchResults.isLoading),
            searchResults.maybeWhen(
              data: (searchResultsData) => searchResultsData == null
                  ? history.userIds.isEmpty && history.queries.isEmpty
                      ? FeedSearchHistoryEmpty()
                      : FeedSearchHistory(userIds: history.userIds, queries: history.queries)
                  : FeedSearchResults(users: searchResultsData),
              orElse: () => FeedSearchResultsSkeleton(),
            ),
          ],
        ),
      ),
    );
  }
}
