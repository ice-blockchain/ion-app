import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/screen_offset/screen_top_offset.dart';
import 'package:ice/app/features/feed/feed_search/providers/feed_search_history_store_provider.dart';
import 'package:ice/app/features/feed/feed_search/providers/feed_simple_search_results.dart';
import 'package:ice/app/features/feed/feed_search/views/pages/feed_simple_search_page/components/feed_search_empty_history/feed_search_empty_history.dart';
import 'package:ice/app/features/feed/feed_search/views/pages/feed_simple_search_page/components/feed_search_navigation/feed_search_navigation.dart';
import 'package:ice/app/features/feed/feed_search/views/pages/feed_simple_search_page/components/feed_search_results/feed_search_results.dart';
import 'package:ice/app/features/feed/feed_search/views/pages/feed_simple_search_page/components/feed_search_history/feed_search_history.dart';

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
            FeedSearchNavigation(query: query),
            searchResults.maybeWhen(
              data: (searchResultsData) => searchResultsData == null
                  ? history.maybeWhen(
                      data: (historyData) =>
                          historyData.users.isEmpty && historyData.queries.isEmpty
                              ? FeedSearchEmptyHistory()
                              : FeedSearchHistory(
                                  users: historyData.users,
                                  queries: historyData.queries,
                                ),
                      orElse: () => SizedBox.shrink(),
                    )
                  : FeedSearchResults(users: searchResultsData),
              orElse: () => SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}
