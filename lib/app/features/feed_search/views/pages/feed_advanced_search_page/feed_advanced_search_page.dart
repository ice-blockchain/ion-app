// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/screen_offset/screen_top_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/views/components/list_separator/list_separator.dart';
import 'package:ion/app/features/feed_search/model/feed_advanced_search_category.dart';
import 'package:ion/app/features/feed_search/views/pages/feed_advanced_search_page/components/feed_advanced_search_navigation/feed_advanced_search_navigation.dart';
import 'package:ion/app/features/feed_search/views/pages/feed_advanced_search_page/components/feed_advanced_search_tab_bar/feed_advanced_search_tab_bar.dart';
import 'package:ion/app/features/feed_search/views/pages/feed_advanced_search_page/components/feed_advanced_search_top/feed_advanced_search_top.dart';
import 'package:ion/app/features/feed_search/views/pages/feed_advanced_search_page/components/feed_advanced_search_users/feed_advanced_search_users.dart';

class FeedAdvancedSearchPage extends ConsumerWidget {
  const FeedAdvancedSearchPage({required this.query, super.key});

  final String query;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: ScreenTopOffset(
        child: DefaultTabController(
          length: FeedAdvancedSearchCategory.values.length,
          child: Column(
            children: [
              FeedAdvancedSearchNavigation(query: query),
              SizedBox(height: 16.0.s),
              const FeedAdvancedSearchTabBar(),
              FeedListSeparator(),
              Expanded(
                child: TabBarView(
                  children: FeedAdvancedSearchCategory.values.map((category) {
                    return switch (category) {
                      FeedAdvancedSearchCategory.top => FeedAdvancedSearchTop(query: query),
                      FeedAdvancedSearchCategory.latest => FeedAdvancedSearchTop(query: query),
                      FeedAdvancedSearchCategory.people => FeedAdvancedSearchUsers(query: query),
                      FeedAdvancedSearchCategory.photos => FeedAdvancedSearchTop(query: query),
                      FeedAdvancedSearchCategory.videos => FeedAdvancedSearchTop(query: query),
                      FeedAdvancedSearchCategory.groups => FeedAdvancedSearchTop(query: query),
                      FeedAdvancedSearchCategory.channels => FeedAdvancedSearchTop(query: query),
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
