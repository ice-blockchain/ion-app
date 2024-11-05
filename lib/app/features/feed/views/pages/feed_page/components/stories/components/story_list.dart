// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/components/scroll_view/load_more_builder.dart';
import 'package:ion/app/features/feed/stories/data/models/story.dart';
import 'package:ion/app/features/feed/views/pages/feed_page/components/stories/components/story_list_item.dart';
import 'package:ion/app/features/feed/views/pages/feed_page/components/stories/components/story_list_separator.dart';
import 'package:ion/app/features/feed/views/pages/feed_page/components/stories/mock.dart';

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
      child: LoadMoreBuilder(
        slivers: const [],
        hasMore: true,
        onLoadMore: () async {
          print('STORIES LOAD MORE');
          await Future.delayed(const Duration(seconds: 4));
        },
        builder: (context, slivers) {
          return ListView.separated(
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
                imageUrl: story.data.imageUrl,
                label: story.data.author,
                nft: story.data.nft,
                me: story.data.me,
                gradient: storyBorderGradients[story.data.gradientIndex],
              );
            },
          );
        },
      ),
    );
  }
}
