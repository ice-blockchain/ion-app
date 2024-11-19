// SPDX-License-Identifier: ice License 1.0

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/features/core/model/media_type.dart';
import 'package:ion/app/features/feed/data/models/post_data.dart';
import 'package:ion/app/features/feed/stories/data/models/story.dart';
import 'package:ion/app/features/feed/views/pages/feed_page/components/stories/components/story_list_item.dart';
import 'package:ion/app/features/feed/views/pages/feed_page/components/stories/components/story_list_separator.dart';
import 'package:ion/app/features/feed/views/pages/feed_page/components/stories/mock.dart';
import 'package:ion/app/features/nostr/model/nostr_entity.dart';
import 'package:ion/app/features/user/model/user_metadata.dart';
import 'package:ion/app/features/user/providers/user_metadata_provider.dart';

class StoryList extends ConsumerWidget {
  const StoryList({
    required this.entities,
    super.key,
  });

  final List<NostrEntity> entities;

  static const _defaultAvatarUrl = 'https://i.pravatar.cc/150?u=@me';
  static const _defaultUserLabel = 'you';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: ScreenSideOffset.defaultSmallMargin),
      sliver: SliverList.separated(
        itemCount: entities.length + 1,
        separatorBuilder: (_, __) => const StoryListSeparator(),
        itemBuilder: (_, index) {
          if (index == 0) {
            return StoryListItem(
              imageUrl: _defaultAvatarUrl,
              label: _defaultUserLabel,
              me: true,
              gradient: storyBorderGradients.first,
            );
          }

          final entity = entities[index - 1];

          if (entity is! PostEntity || entity.data.media.isEmpty) {
            return const SizedBox.shrink();
          }

          return ref.read(userMetadataProvider(entity.pubkey)).maybeWhen(
                data: (userMetadata) {
                  final stories = _createStories(entity, userMetadata?.data);
                  if (stories.isEmpty) return const SizedBox.shrink();

                  return StoryListItem(
                    imageUrl: userMetadata?.data.picture ?? _defaultAvatarUrl,
                    label: stories.first.data.author,
                    gradient: storyBorderGradients[Random().nextInt(storyBorderGradients.length)],
                  );
                },
                orElse: () => const SizedBox.shrink(),
              );
        },
      ),
    );
  }

  List<Story> _createStories(PostEntity entity, UserMetadata? userMetadata) {
    return entity.data.media.values.map((mediaAttachment) {
      final storyData = StoryData(
        id: '${entity.id}_${mediaAttachment.url}',
        authorId: entity.pubkey,
        author: userMetadata?.displayName ?? '',
        mediaUrl: mediaAttachment.url,
      );

      return mediaAttachment.mediaType == MediaType.image
          ? Story.image(data: storyData)
          : Story.video(data: storyData);
    }).toList();
  }
}
