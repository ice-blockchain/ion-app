import 'package:flutter/material.dart';
import 'package:ice/app/components/skeleton/skeleton.dart';
import 'package:ice/app/features/feed/feed_search/views/pages/feed_simple_search_page/components/feed_search_results/feed_search_results.dart';
import 'package:ice/app/features/feed/feed_search/views/pages/feed_simple_search_page/components/feed_search_results/feed_search_results_list_item_shape.dart';

class FeedSearchResultsSkeleton extends StatelessWidget {
  const FeedSearchResultsSkeleton({super.key});

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
                (int i) => FeedSearchResultsListItemShape(),
              ).toList(),
            ),
          ),
        ),
      ),
    );
  }
}
