// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/components/list_item/list_item.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/components/skeleton/skeleton.dart';
import 'package:ion/app/features/search/views/pages/feed_simple_search_page/components/search_results/feed_search_results.dart';
import 'package:ion/app/features/search/views/pages/feed_simple_search_page/components/search_results/feed_search_results_list_item.dart';

class SearchResultsSkeleton extends StatelessWidget {
  const SearchResultsSkeleton({super.key});

  static const int numberOfItems = 12;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: OverflowBox(
        maxHeight: double.infinity,
        alignment: Alignment.topCenter,
        child: Skeleton(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: FeedSearchResults.listVerticalOffset),
            child: Column(
              children: List.generate(
                numberOfItems,
                (_) => ScreenSideOffset.small(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: FeedSearchResultsListItem.itemVerticalOffset,
                    ),
                    child: const ListItemUserShape(),
                  ),
                ),
              ).toList(),
            ),
          ),
        ),
      ),
    );
  }
}
