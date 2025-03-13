// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/feed/stories/data/models/story.c.dart';
import 'package:ion/app/features/feed/stories/data/models/story_viewer_state.c.dart';
import 'package:ion/app/features/feed/stories/providers/story_viewing_provider.c.dart';
import 'package:ion/app/features/feed/stories/views/components/story_viewer/components/core/core.dart';
import 'package:ion/app/utils/future.dart';

class StoriesSwiper extends HookConsumerWidget {
  const StoriesSwiper({
    required this.userStories,
    required this.currentUserIndex,
    required this.pubkey,
    super.key,
  });

  final List<UserStories> userStories;
  final int currentUserIndex;
  final String pubkey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userPageController = usePageController(initialPage: currentUserIndex);

    ref.listen<StoryViewerState>(storyViewingControllerProvider(pubkey), (previous, next) {
      if (previous?.currentUserIndex != next.currentUserIndex) {
        userPageController.animateToPage(
          next.currentUserIndex,
          duration: 300.ms,
          curve: Curves.easeInOut,
        );
      }
    });

    return CubePageView.builder(
      controller: userPageController,
      itemCount: userStories.length,
      onPageChanged: ref.read(storyViewingControllerProvider(pubkey).notifier).moveToUser,
      itemBuilder: (context, userIndex, pageNotifier) {
        final userStory = userStories[userIndex];
        final isCurrentUser = userIndex == currentUserIndex;

        final storyNotifier = ref.read(storyViewingControllerProvider(pubkey).notifier);

        return CubeWidget(
          index: userIndex,
          pageNotifier: pageNotifier,
          child: UserStoryPageView(
            pubkey: pubkey,
            userStory: userStory,
            isCurrentUser: isCurrentUser,
            onNextStory: storyNotifier.moveToNextStory,
            onPreviousStory: storyNotifier.moveToPreviousStory,
            onNextUser: () => userPageController.hasClients && userIndex < userStories.length - 1
                ? userPageController.nextPage(
                    duration: 300.ms,
                    curve: Curves.easeInOut,
                  )
                : context.pop(),
            onPreviousUser: () => userPageController.hasClients && userIndex > 0
                ? userPageController.previousPage(
                    duration: 300.ms,
                    curve: Curves.easeInOut,
                  )
                : context.pop(),
          ),
        );
      },
    );
  }
}
