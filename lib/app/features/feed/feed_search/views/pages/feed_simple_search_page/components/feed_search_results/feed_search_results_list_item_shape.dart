import 'package:flutter/material.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/feed/feed_search/views/pages/feed_simple_search_page/components/feed_search_results/feed_search_results_list_item.dart';

class FeedSearchResultsListItemShape extends StatelessWidget {
  const FeedSearchResultsListItemShape({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenSideOffset.small(
      child: Container(
        height: 36.0.s,
        margin: EdgeInsets.symmetric(vertical: FeedSearchResultsListItem.itemVerticalOffset),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.0.s),
          color: Colors.white,
        ),
      ),
    );
  }
}
