import 'package:flutter/material.dart';
import 'package:ice/app/components/screen_side_offset/screen_side_offset.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/features/feed/views/pages/feed_page/components/stories/components/story_list_item.dart';
import 'package:ice/app/features/feed/views/pages/feed_page/components/stories/mock.dart';

class Stories extends StatelessWidget {
  const Stories({super.key});

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
          return SizedBox(width: 12.0.s);
        },
        itemBuilder: (BuildContext context, int index) {
          final Story story = stories[index];
          return StoryListItem(
            imageUrl: story.imageUrl,
            label: story.author,
            showPlus: story.me,
          );
        },
      ),
    );
  }
}
