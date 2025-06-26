// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/nothing_is_found/nothing_is_found.dart';
import 'package:ion/app/components/screen_offset/screen_top_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/search/providers/dapps_search_history_provider.m.dart';
import 'package:ion/app/features/search/providers/dapps_search_provider.r.dart';
import 'package:ion/app/features/search/views/components/dapps_search_history/dapps_search_history_list_item.dart';
import 'package:ion/app/features/search/views/components/search_history/search_history.dart';
import 'package:ion/app/features/search/views/components/search_history_empty/search_history_empty.dart';
import 'package:ion/app/features/search/views/components/search_navigation/search_navigation.dart';
import 'package:ion/app/features/search/views/components/search_results_skeleton/search_results_skeleton.dart';
import 'package:ion/app/features/search/views/pages/dapps_simple_search_page/components/search_results/dapps_search_results.dart';
import 'package:ion/app/router/app_routes.gr.dart';

class DAppsSimpleSearchPage extends ConsumerWidget {
  const DAppsSimpleSearchPage({required this.query, super.key});

  final String query;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final history = ref.watch(dAppsSearchHistoryProvider);
    final dAppsSearchResults = ref.watch(dAppsSearchProvider(query));

    return Scaffold(
      body: ScreenTopOffset(
        child: Column(
          children: [
            SearchNavigation(
              query: query,
              showBackButton: true,
              showCancelButton: false,
              loading: dAppsSearchResults.isLoading,
              onTextChanged: (String text) {
                DAppsSimpleSearchRoute(query: text).replace(context);
              },
            ),
            dAppsSearchResults.maybeWhen(
              data: (apps) {
                /// Since for dApps there is no additional search page,
                /// the more appropriate way to save query history is to write is on dApps data load.
                if (query.isNotEmpty) {
                  ref.read(dAppsSearchHistoryProvider.notifier).addQueryToTheHistory(query);
                }

                return apps == null
                    ? history.ids.isEmpty && history.queries.isEmpty
                        ? SearchHistoryEmpty(
                            title: context.i18n.dapps_search_empty,
                          )
                        : SearchHistory(
                            itemCount: history.ids.length,
                            queries: history.queries,
                            onSelectQuery: (String query) {
                              DAppsSimpleSearchRoute(query: query).replace(context);
                            },
                            onClearHistory: () {
                              ref.read(dAppsSearchHistoryProvider.notifier).clear();
                            },
                            itemBuilder: (context, index) => DAppsSearchHistoryListItem(
                              id: history.ids[index],
                            ),
                          )
                    : apps.isEmpty
                        ? NothingIsFound(
                            title: context.i18n.search_nothing_found,
                          )
                        : DAppsSearchResults(apps: apps);
              },
              orElse: SearchResultsSkeleton.new,
            ),
          ],
        ),
      ),
    );
  }
}
