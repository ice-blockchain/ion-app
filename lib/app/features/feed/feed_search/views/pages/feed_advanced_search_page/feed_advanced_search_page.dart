import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/screen_offset/screen_top_offset.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/feed/feed_search/model/feed_advanced_search_category.dart';
import 'package:ice/app/features/feed/feed_search/views/pages/feed_advanced_search_page/components/feed_advanced_search_navigation/feed_advanced_search_navigation.dart';
import 'package:ice/app/features/feed/feed_search/views/pages/feed_advanced_search_page/components/feed_advanced_search_tab_bar/feed_advanced_search_tab_bar.dart';
import 'package:ice/app/features/feed/feed_search/views/pages/feed_advanced_search_page/components/feed_advanced_search_top/feed_advanced_search_top.dart';
import 'package:ice/app/features/feed/feed_search/views/pages/feed_advanced_search_page/components/feed_advanced_search_users/feed_advanced_search_users.dart';
import 'package:ice/app/features/feed/views/components/list_separator/list_separator.dart';

class FeedAdvancedSearchPage extends ConsumerWidget {
  const FeedAdvancedSearchPage({super.key, required this.query});

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
              FeedAdvancedSearchTabBar(),
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
