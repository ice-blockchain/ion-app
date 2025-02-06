// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/feed/stories/providers/stories_provider.c.dart';
import 'package:ion/app/features/feed/stories/providers/viewed_stories_provider.c.dart';
import 'package:ion/app/features/feed/views/pages/feed_page/components/stories/components/user_story_list_item.dart';
import 'package:ion/app/features/user/providers/user_metadata_provider.c.dart';
import 'package:ion/app/router/app_routes.c.dart';

class StoryListItem extends HookConsumerWidget {
  const StoryListItem({
    required this.pubkey,
    super.key,
    this.gradient,
  });

  final String pubkey;
  final Gradient? gradient;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userMetadataAsync = ref.watch(userMetadataProvider(pubkey, network: false));
    final userStories = ref.watch(filteredStoriesByPubkeyProvider(pubkey));
    final viewedStories = ref.watch(viewedStoriesControllerProvider);

    final allStoriesViewed = userStories.first.stories.every(
      (story) => viewedStories.contains(story.id),
    );

    return userMetadataAsync.maybeWhen(
      data: (userMetadata) {
        if (userMetadata == null) return const SizedBox.shrink();

        return Hero(
          tag: 'story-$pubkey',
          child: Material(
            color: Colors.transparent,
            child: UserStoryListItem(
              imageUrl: userMetadata.data.picture,
              name: userMetadata.data.name,
              gradient: gradient,
              isViewed: allStoriesViewed,
              onTap: () => StoryViewerRoute(pubkey: pubkey).push<void>(context),
            ),
          ),
        );
      },
      orElse: () => const SizedBox.shrink(),
    );
  }
}
