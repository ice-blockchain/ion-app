// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/feed/stories/providers/feed_stories_provider.c.dart';
import 'package:ion/app/features/feed/stories/providers/viewed_stories_provider.c.dart';
import 'package:ion/app/features/feed/views/pages/feed_page/components/stories/components/story_item_content.dart';
import 'package:ion/app/features/feed/views/pages/feed_page/components/stories/mock.dart';
import 'package:ion/app/features/user/providers/user_metadata_provider.c.dart';
import 'package:ion/app/router/app_routes.c.dart';

class StoryListItem extends HookConsumerWidget {
  const StoryListItem({
    required this.pubkey,
    super.key,
  });

  final String pubkey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userMetadata = ref.watch(cachedUserMetadataProvider(pubkey));
    final userStories = ref.watch(feedStoriesByPubkeyProvider(pubkey));
    final viewedStories = ref.watch(viewedStoriesControllerProvider);
    final gradient = useRef(storyBorderGradients[random.nextInt(storyBorderGradients.length)]);

    final allStoriesViewed = useMemoized(
      () => userStories.first.stories.every(
        (story) => viewedStories.contains(story.id),
      ),
      [userStories, viewedStories],
    );

    if (userMetadata == null) {
      return const SizedBox.shrink();
    }

    return Material(
      color: Colors.transparent,
      child: StoryItemContent(
        pubkey: pubkey,
        name: userMetadata.data.name,
        gradient: gradient.value,
        isViewed: allStoriesViewed,
        onTap: () => StoryViewerRoute(pubkey: pubkey).push<void>(context),
      ),
    );
  }
}
