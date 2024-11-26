// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/feed/stories/data/models/story.dart';
import 'package:ion/app/features/feed/stories/providers/story_viewing_provider.dart';
import 'package:ion/app/features/feed/stories/views/components/story_viewer/components/core/core.dart';
import 'package:ion/app/utils/future.dart';

class StoriesSwiper extends HookConsumerWidget {
  const StoriesSwiper({
    required this.userStories,
    required this.currentUserIndex,
    super.key,
  });

  final List<UserStories> userStories;
  final int currentUserIndex;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userPageController = usePageController(initialPage: currentUserIndex);

    return CubePageView.builder(
      controller: userPageController,
      itemCount: userStories.length,
      onPageChanged: ref.read(storyViewingControllerProvider.notifier).moveToUser,
      itemBuilder: (context, userIndex, pageNotifier) {
        final userStory = userStories[userIndex];
        final isCurrentUser = userIndex == currentUserIndex;

        final storyController = ref.read(storyViewingControllerProvider);
        final storyNotifier = ref.read(storyViewingControllerProvider.notifier);

        return CubeWidget(
          index: userIndex,
          pageNotifier: pageNotifier,
          child: UserStoryPageView(
            userStory: userStory,
            isCurrentUser: isCurrentUser,
            currentStoryIndex: isCurrentUser ? storyController.currentStoryIndex : 0,
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
