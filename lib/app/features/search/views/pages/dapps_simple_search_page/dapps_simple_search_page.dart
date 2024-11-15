// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/screen_offset/screen_top_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/search/providers/dapps_search_provider.dart';
import 'package:ion/app/features/search/providers/feed_search_history_provider.dart'
    show feedSearchHistoryProvider;
import 'package:ion/app/features/search/views/components/nothing_is_found/nothing_is_found.dart';
import 'package:ion/app/features/search/views/components/search_history/search_history.dart';
import 'package:ion/app/features/search/views/components/search_history_empty/search_history_empty.dart';
import 'package:ion/app/features/search/views/components/search_navigation/search_navigation.dart';
import 'package:ion/app/features/search/views/components/search_results_skeleton/search_results_skeleton.dart';
import 'package:ion/app/features/search/views/pages/dapps_simple_search_page/components/search_results/dapps_search_results.dart';
import 'package:ion/app/router/app_routes.dart';

class DAppsSimpleSearchPage extends ConsumerWidget {
  const DAppsSimpleSearchPage({required this.query, super.key});

  final String query;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final history = ref.watch(feedSearchHistoryProvider);
    final dAppsSearchResults = ref.watch(dAppsSearchProvider(query));

    return Scaffold(
      body: ScreenTopOffset(
        child: Column(
          children: [
            SearchNavigation(
              query: query,
              loading: dAppsSearchResults.isLoading,
              onSubmitted: (String query) {
                debugPrint('SearchNavigation query: $query');
              },
              onTextChanged: (String text) {
                DAppsSimpleSearchRoute(query: text).replace(context);
              },
            ),
            dAppsSearchResults.maybeWhen(
              data: (apps) => apps == null
                  ? history.pubKeys.isEmpty && history.queries.isEmpty
                      ? SearchHistoryEmpty(
                          title: context.i18n.dapps_search_empty,
                        )
                      : SearchHistory(
                          pubKeys: history.pubKeys,
                          queries: history.queries,
                          onSelectQuery: (String query) {
                            FeedSimpleSearchRoute(query: query)
                                .replace(context);
                          },
                          onClearHistory: () {
                            ref
                                .read(feedSearchHistoryProvider.notifier)
                                .clear();
                          },
                        )
                  : apps.isEmpty
                      ? NothingIsFound(
                          title: context.i18n.search_nothing_found,
                        )
                      : DAppsSearchResults(apps: apps),
              orElse: SearchResultsSkeleton.new,
            ),
          ],
        ),
      ),
    );
  }
}
