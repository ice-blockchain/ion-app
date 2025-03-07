// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/components/list_item/list_item.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/components/separated/separated_row.dart';
import 'package:ion/app/components/skeleton/skeleton.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/data/models/trending_videos_overlay.dart';
import 'package:ion/app/features/feed/views/pages/feed_page/components/trending_videos/components/trending_videos_list_item_skeleton.dart';
import 'package:ion/app/features/feed/views/pages/feed_page/components/trending_videos/components/trending_videos_list_separator.dart';

class TrendingVideosListSkeleton extends StatelessWidget {
  const TrendingVideosListSkeleton({
    required this.listOverlay,
    super.key,
  });

  final TrendingVideosOverlay listOverlay;

  static const int numberOfItems = 5;

  @override
  Widget build(BuildContext context) {
    return Skeleton(
      child: Column(
        children: [
          ScreenSideOffset.small(
            child: ListItem(constraints: BoxConstraints(minHeight: 26.0.s)),
          ),
          SizedBox(height: 10.0.s),
          SizedBox(
            height: listOverlay.itemSize.height,
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
        ],
      ),
    );
  }
}
