// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/feed/stories/providers/story_viewing_provider.dart';
import 'package:ion/app/features/feed/stories/views/components/story_viewer/components/core/core.dart';
import 'package:ion/app/utils/future.dart';

class StoriesSwiper extends HookConsumerWidget {
  const StoriesSwiper({
    required this.pubkey,
    super.key,
  });

  final String pubkey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final storyState = ref.watch(storyViewingControllerProvider(startingPubkey: pubkey));
    final userPageController = usePageController(initialPage: storyState.currentUserIndex);

    return CubePageView.builder(
      controller: userPageController,
      itemCount: storyState.userStories.length,
      onPageChanged:
          ref.read(storyViewingControllerProvider(startingPubkey: pubkey).notifier).moveToUser,
      itemBuilder: (context, userIndex, userNotifier) {
        final userStory = storyState.userStories[userIndex];
        final isCurrentUser = userIndex == storyState.currentUserIndex;

        return CubeWidget(
          index: userIndex,
          pageNotifier: userNotifier,
          child: Consumer(
            builder: (context, ref, _) {
              return UserStoryPageView(
                userStory: userStory,
                isCurrentUser: isCurrentUser,
                currentStoryIndex: isCurrentUser ? storyState.currentStoryIndex : 0,
                onNextStory: ref
                    .read(storyViewingControllerProvider(startingPubkey: pubkey).notifier)
                    .moveToNextStory,
                onPreviousStory: ref
                    .read(storyViewingControllerProvider(startingPubkey: pubkey).notifier)
                    .moveToPreviousStory,
                onNextUser: () {
                  if (userPageController.hasClients &&
                      userIndex < storyState.userStories.length - 1) {
                    userPageController.nextPage(
                      duration: 300.ms,
                      curve: Curves.easeInOut,
                    );
                  } else {
                    context.pop();
                  }
                },
                onPreviousUser: () {
                  if (userPageController.hasClients && userIndex > 0) {
                    userPageController.previousPage(
                      duration: 300.ms,
                      curve: Curves.easeInOut,
                    );
                  } else {
                    context.pop();
                  }
                },
              );
            },
          ),
        );
      },
    );
  }
}
