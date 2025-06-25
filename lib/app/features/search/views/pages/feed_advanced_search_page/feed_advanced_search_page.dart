// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/screen_offset/screen_top_offset.dart';
import 'package:ion/app/components/section_separator/section_separator.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/search/model/advanced_search_category.dart';
import 'package:ion/app/features/search/providers/feed_search_categories.c.dart';
import 'package:ion/app/features/search/views/components/advanced_search_navigation/advanced_search_navigation.dart';
import 'package:ion/app/features/search/views/components/advanced_search_tab_bar/advanced_search_tab_bar.dart';
import 'package:ion/app/features/search/views/pages/feed_advanced_search_page/components/feed_advanced_search_posts/feed_advanced_search_posts.dart';
import 'package:ion/app/features/search/views/pages/feed_advanced_search_page/components/feed_advanced_search_users/feed_advanced_search_users.dart';
import 'package:ion/app/router/app_routes.c.dart';

class FeedAdvancedSearchPage extends HookConsumerWidget {
  const FeedAdvancedSearchPage({required this.query, super.key});

  final String query;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(searchCategoriesProvider);

    return Scaffold(
      body: ScreenTopOffset(
        child: DefaultTabController(
          length: categories.length,
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
              const SectionSeparator(),
              Expanded(
                child: TabBarView(
                  children: categories.map((category) {
                    return switch (category) {
                      AdvancedSearchCategory.trending ||
                      AdvancedSearchCategory.top ||
                      AdvancedSearchCategory.latest ||
                      AdvancedSearchCategory.photos ||
                      AdvancedSearchCategory.videos =>
                        FeedAdvancedSearchPosts(query: query, category: category),
                      AdvancedSearchCategory.people => FeedAdvancedSearchUsers(query: query),
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
