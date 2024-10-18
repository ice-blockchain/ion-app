// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/feed_search/model/feed_advanced_search_category.dart';
import 'package:ion/app/features/feed/feed_search/views/pages/feed_advanced_search_page/components/feed_advanced_search_tab_bar/feed_advanced_search_tab.dart';

class FeedAdvancedSearchTabBar extends StatelessWidget {
  const FeedAdvancedSearchTabBar({super.key});

  static double get _tabItemHorizontalGap => 16.0.s;

  @override
  Widget build(BuildContext context) {
    return TabBar(
      padding: EdgeInsets.symmetric(
        horizontal: ScreenSideOffset.defaultSmallMargin - _tabItemHorizontalGap / 2,
      ),
      tabAlignment: TabAlignment.start,
      isScrollable: true,
      labelPadding: EdgeInsets.symmetric(horizontal: _tabItemHorizontalGap / 2),
      labelColor: context.theme.appColors.primaryAccent,
      unselectedLabelColor: context.theme.appColors.tertararyText,
      tabs: FeedAdvancedSearchCategory.values.map((category) {
        return FeedAdvancedSearchTab(category: category);
      }).toList(),
      indicatorColor: context.theme.appColors.primaryAccent,
      dividerHeight: 0,
    );
  }
}
