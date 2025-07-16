// SPDX-License-Identifier: ice License 1.0

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/feed/stories/data/models/stories_references.f.dart';
import 'package:ion/app/features/feed/stories/providers/feed_stories_provider.r.dart';
import 'package:ion/app/features/feed/stories/providers/viewed_stories_provider.r.dart';
import 'package:ion/app/features/feed/views/pages/feed_page/components/stories/components/story_item_content.dart';
import 'package:ion/app/features/feed/views/pages/feed_page/components/stories/mock.dart';
import 'package:ion/app/features/user/providers/user_metadata_provider.r.dart';
import 'package:ion/app/router/app_routes.gr.dart';

class StoryListItem extends HookConsumerWidget {
  const StoryListItem({
    required this.pubkey,
    super.key,
  });

  final String pubkey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userMetadata = ref.watch(cachedUserMetadataProvider(pubkey));
    final userStory = ref.watch(feedStoriesByPubkeyProvider(pubkey, showOnlySelectedUser: true));
    final storyReference = StoriesReferences(userStory.map((e) => e.story.toEventReference()));
    final viewedStories = ref.watch(viewedStoriesControllerProvider(storyReference));
    final gradient = useRef(storyBorderGradients[Random().nextInt(storyBorderGradients.length)]);

    final allStoriesViewed = useMemoized(
      () => viewedStories == null || viewedStories.isNotEmpty,
      [viewedStories],
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
