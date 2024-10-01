// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/components/separated/separated_row.dart';
import 'package:ice/app/components/skeleton/skeleton.dart';
import 'package:ice/app/features/feed/views/pages/feed_page/components/stories/components/story_list_item.dart';
import 'package:ice/app/features/feed/views/pages/feed_page/components/stories/components/story_list_item_skeleton.dart';
import 'package:ice/app/features/feed/views/pages/feed_page/components/stories/components/story_list_separator.dart';

class StoryListSkeleton extends StatelessWidget {
  const StoryListSkeleton({
    super.key,
  });

  static const int numberOfItems = 10;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: StoryListItem.height,
      child: Skeleton(
        child: OverflowBox(
          maxWidth: double.infinity,
          alignment: Alignment.centerLeft,
          child: ScreenSideOffset.small(
            child: SeparatedRow(
              separator: const StoryListSeparator(),
              children: List.generate(
                numberOfItems,
                (int i) => const StoryListItemSkeleton(),
              ).toList(),
            ),
          ),
        ),
      ),
    );
  }
}
