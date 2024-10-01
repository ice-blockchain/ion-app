// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/features/feed/views/pages/feed_page/components/stories/components/story_list_item.dart';
import 'package:ice/app/features/feed/views/pages/feed_page/components/stories/components/story_list_separator.dart';
import 'package:ice/app/features/feed/views/pages/feed_page/components/stories/mock.dart';

class StoryList extends StatelessWidget {
  const StoryList({
    required this.stories,
    super.key,
  });

  final List<Story> stories;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: StoryListItem.height,
      child: ListView.separated(
        padding: EdgeInsets.symmetric(
          horizontal: ScreenSideOffset.defaultSmallMargin,
        ),
        scrollDirection: Axis.horizontal,
        itemCount: stories.length,
        separatorBuilder: (BuildContext context, int index) {
          return const StoryListSeparator();
        },
        itemBuilder: (BuildContext context, int index) {
          final story = stories[index];
          return StoryListItem(
            imageUrl: story.imageUrl,
            label: story.author,
            nft: story.nft,
            me: story.me,
            gradient: storyBorderGradients[story.gradientIndex],
          );
        },
      ),
    );
  }
}
