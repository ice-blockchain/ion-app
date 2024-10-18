// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/extensions/build_context.dart';
import 'package:ion/app/extensions/num.dart';
import 'package:ion/app/extensions/theme_data.dart';
import 'package:ion/app/features/feed/views/pages/feed_page/components/stories/components/story_list_item.dart';

class StoryListItemSkeleton extends StatelessWidget {
  const StoryListItemSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final textStyle = context.theme.appTextThemes.caption3;

    return SizedBox(
      width: StoryListItem.width,
      height: StoryListItem.height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: StoryListItem.width,
            height: StoryListItem.width,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(19.5.s),
            ),
          ),
          Container(
            height: textStyle.fontSize! * textStyle.height!,
            alignment: Alignment.center,
            child: Container(
              height: textStyle.fontSize,
              width: StoryListItem.width * 0.8,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(textStyle.fontSize! / 2),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
