import 'package:flutter/material.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/components/separated/separated_row.dart';
import 'package:ice/app/components/skeleton/skeleton.dart';
import 'package:ice/app/features/feed/data/models/trending_videos_overlay.dart';
import 'package:ice/app/features/feed/views/pages/feed_page/components/trending_videos/components/trending_videos_list_item_skeleton.dart';
import 'package:ice/app/features/feed/views/pages/feed_page/components/trending_videos/components/trending_videos_list_separator.dart';

class TrendingVideosListSkeleton extends StatelessWidget {
  const TrendingVideosListSkeleton({
    required this.listOverlay,
    super.key,
  });

  final TrendingVideosOverlay listOverlay;

  static const int numberOfItems = 5;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: listOverlay.itemSize.height,
      child: Skeleton(
        child: OverflowBox(
          maxWidth: double.infinity,
          alignment: Alignment.centerLeft,
          child: ScreenSideOffset.small(
            child: SeparatedRow(
              separator: const TrendingVideosListSeparator(),
              children: List.generate(
                numberOfItems,
                (int i) => TrendingVideoListItemSkeleton(
                  itemSize: listOverlay.itemSize,
                ),
              ).toList(),
            ),
          ),
        ),
      ),
    );
  }
}
