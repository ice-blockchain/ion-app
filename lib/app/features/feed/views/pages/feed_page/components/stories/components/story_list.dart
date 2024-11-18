// SPDX-License-Identifier: ice License 1.0

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/features/feed/data/models/post_data.dart';
import 'package:ion/app/features/feed/stories/data/models/story.dart';
import 'package:ion/app/features/feed/views/pages/feed_page/components/stories/components/story_list_item.dart';
import 'package:ion/app/features/feed/views/pages/feed_page/components/stories/components/story_list_separator.dart';
import 'package:ion/app/features/feed/views/pages/feed_page/components/stories/mock.dart';
import 'package:ion/app/features/nostr/model/nostr_entity.dart';
import 'package:ion/app/features/user/providers/user_metadata_provider.dart';

class StoryList extends ConsumerWidget {
  const StoryList({
    required this.entities,
    super.key,
  });

  final List<NostrEntity> entities;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entities = this.entities;

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
              label: 'You',
              me: true,
              gradient: storyBorderGradients.first,
            );
          }

          final entity = entities[index - 1];

          if (entity is PostEntity) {
            final mediaAttachments = entity.data.media.values;

            if (mediaAttachments.isEmpty) {
              return const SizedBox.shrink();
            }

            final userMetadataAsync = ref.watch(userMetadataProvider(entity.pubkey));

            return userMetadataAsync.maybeWhen(
              orElse: () => const SizedBox.shrink(),
              data: (userMetadata) {
                final story = Story.fromPostEntity(entity, userMetadata?.data);

                return StoryListItem(
                  imageUrl: story.data.mediaUrl,
                  label: story.data.author,
                  gradient: storyBorderGradients[Random().nextInt(storyBorderGradients.length)],
                );
              },
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
