// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/screen_offset/screen_top_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/views/components/list_separator/list_separator.dart';
import 'package:ion/app/features/search/model/advanced_search_category.dart';
import 'package:ion/app/features/search/views/components/advanced_search_navigation/advanced_search_navigation.dart';
import 'package:ion/app/features/search/views/components/advanced_search_tab_bar/advanced_search_tab_bar.dart';
import 'package:ion/app/features/search/views/pages/feed_advanced_search_page/components/feed_advanced_search_top/feed_advanced_search_top.dart';
import 'package:ion/app/features/search/views/pages/feed_advanced_search_page/components/feed_advanced_search_users/feed_advanced_search_users.dart';
import 'package:ion/app/router/app_routes.dart';

class FeedAdvancedSearchPage extends HookConsumerWidget {
  const FeedAdvancedSearchPage({required this.query, super.key});

  final String query;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = useMemoized(
      () {
        return AdvancedSearchCategory.values.where((category) => category.isFeed).toList();
      },
      [],
    );

    return Scaffold(
      body: ScreenTopOffset(
        child: DefaultTabController(
          length: AdvancedSearchCategory.values.length,
          child: Column(
            children: [
              AdvancedSearchNavigation(
                query: query,
                onTapSearch: () {
                  FeedSimpleSearchRoute(query: query).push<void>(context);
                },
                onFiltersPressed: () {
                  FeedSearchFiltersRoute().push<void>(context);
                },
              ),
              SizedBox(height: 16.0.s),
              AdvancedSearchTabBar(
                categories: categories,
              ),
              FeedListSeparator(),
              Expanded(
                child: TabBarView(
                  children: categories.map((category) {
                    return switch (category) {
                      AdvancedSearchCategory.top => FeedAdvancedSearchTop(query: query),
                      AdvancedSearchCategory.latest => FeedAdvancedSearchTop(query: query),
                      AdvancedSearchCategory.people => FeedAdvancedSearchUsers(query: query),
                      AdvancedSearchCategory.photos => FeedAdvancedSearchTop(query: query),
                      AdvancedSearchCategory.videos => FeedAdvancedSearchTop(query: query),
                      AdvancedSearchCategory.groups => FeedAdvancedSearchTop(query: query),
                      AdvancedSearchCategory.channels => FeedAdvancedSearchTop(query: query),
                      _ => const SizedBox.shrink(),
                    };
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
