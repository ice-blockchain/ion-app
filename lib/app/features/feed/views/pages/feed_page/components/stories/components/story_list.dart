// SPDX-License-Identifier: ice License 1.0

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/features/feed/data/models/post_data.dart';
import 'package:ion/app/features/feed/stories/data/models/story.dart';
import 'package:ion/app/features/feed/views/pages/feed_page/components/stories/components/story_list_item.dart';
import 'package:ion/app/features/feed/views/pages/feed_page/components/stories/components/story_list_separator.dart';
import 'package:ion/app/features/feed/views/pages/feed_page/components/stories/mock.dart';
import 'package:ion/app/features/nostr/model/nostr_entity.dart';

class StoryList extends StatelessWidget {
  const StoryList({
    required this.entities,
    super.key,
  });

  final List<NostrEntity> entities;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: EdgeInsets.symmetric(
        horizontal: ScreenSideOffset.defaultSmallMargin,
      ),
      sliver: SliverList.separated(
        itemCount: entities.length + 1,
        separatorBuilder: (BuildContext context, int index) {
          return const StoryListSeparator();
        },
        itemBuilder: (BuildContext context, int index) {
          if (index == 0) {
            return StoryListItem(
              imageUrl: 'https://i.pravatar.cc/150?u=@me',
              label: 'you',
              me: true,
              gradient: storyBorderGradients.first,
            );
          }

          final entity = entities[index - 1];
          if (entity is PostEntity) {
            //TODO::use entity for data instead of mocked stories
          }
          final story = Story.image(
            data: StoryData(
              id: index.toString(),
              authorId: 'john',
              author: 'Someone',
              contentUrl: 'https://picsum.photos/500/800?random=$index',
              imageUrl: 'https://i.pravatar.cc/150?u=@john_avatar$index',
            ),
          );
          return StoryListItem(
            imageUrl: story.data.imageUrl,
            label: story.data.author,
            gradient: storyBorderGradients[Random().nextInt(storyBorderGradients.length)],
          );
        },
      ),
    );
  }
}
