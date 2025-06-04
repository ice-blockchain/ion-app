// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/feed/stories/data/models/story.c.dart';
import 'package:ion/app/features/feed/stories/data/models/story_viewer_state.c.dart';
import 'package:ion/app/features/feed/stories/providers/story_viewing_provider.c.dart';
import 'package:ion/app/features/feed/stories/views/components/story_viewer/components/core/core.dart';

const Key storiesSwiperKey = Key('stories_swiper');
const Duration _pageTransitionDuration = Duration(milliseconds: 100);

class StoriesSwiper extends HookConsumerWidget {
  const StoriesSwiper({
    required this.userStories,
    required this.currentUserIndex,
    required this.pubkey,
    Key? key,
  }) : super(key: key ?? storiesSwiperKey);

  final List<UserStories> userStories;
  final int currentUserIndex;
  final String pubkey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userPageController = usePageController(initialPage: currentUserIndex);

    ref.listen<StoryViewerState>(
      storyViewingControllerProvider(pubkey),
      (prev, next) {
        if (prev?.currentUserIndex != next.currentUserIndex && userPageController.hasClients) {
          userPageController.animateToPage(
            next.currentUserIndex,
            duration: _pageTransitionDuration,
            curve: Curves.easeInOut,
          );
        }
      },
    );

    final storyNotifier = ref.read(
      storyViewingControllerProvider(pubkey).notifier,
    );

    return CubePageView.builder(
      controller: userPageController,
      itemCount: userStories.length,
      onPageChanged: (newIndex) {
        final currentIndex = ref.read(storyViewingControllerProvider(pubkey)).currentUserIndex;

        if (newIndex != currentIndex) {
          storyNotifier.moveToUser(newIndex);
        }
      },
      itemBuilder: (context, userIndex, pageNotifier) {
        final userStory = userStories[userIndex];
        final isCurrentUser = userIndex == currentUserIndex;

        void closeViewer() => context.pop();

        return CubeWidget(
          index: userIndex,
          pageNotifier: pageNotifier,
          child: UserStoryPageView(
            pubkey: pubkey,
            userStory: userStory,
            isCurrentUser: isCurrentUser,
            onNextStory: () => storyNotifier.advance(onClose: closeViewer),
            onPreviousStory: () => storyNotifier.rewind(onClose: closeViewer),
            onNextUser: () {
              if (userPageController.hasClients && userIndex < userStories.length - 1) {
                userPageController.nextPage(
                  duration: _pageTransitionDuration,
                  curve: Curves.easeInOut,
                );
              } else {
                closeViewer();
              }
            },
            onPreviousUser: () {
              if (userPageController.hasClients && userIndex > 0) {
                userPageController.previousPage(
                  duration: _pageTransitionDuration,
                  curve: Curves.easeInOut,
                );
              } else {
                closeViewer();
              }
            },
          ),
        );
      },
    );
  }
}
