// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/components/separated/separated_row.dart';
import 'package:ion/app/components/skeleton/skeleton.dart';
import 'package:ion/app/features/feed/views/pages/feed_page/components/stories/components/story_item_content.dart';
import 'package:ion/app/features/feed/views/pages/feed_page/components/stories/components/story_list_item_skeleton.dart';
import 'package:ion/app/features/feed/views/pages/feed_page/components/stories/components/story_list_separator.dart';

class StoryListSkeleton extends StatelessWidget {
  const StoryListSkeleton({
    super.key,
  });

  static const int numberOfItems = 10;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: StoryItemContent.height,
      child: Skeleton(
        child: OverflowBox(
          maxWidth: double.infinity,
          alignment: AlignmentDirectional.centerStart,
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
