// SPDX-License-Identifier: ice License 1.0

import 'package:cube_transition_plus/cube_transition_plus.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/create_story/data/models/story.dart';
import 'package:ion/app/features/feed/create_story/providers/story_viewing_provider.dart';
import 'package:ion/app/features/feed/create_story/views/components/story_viewer/components/story_viewer_content.dart';
import 'package:ion/app/features/feed/create_story/views/components/story_viewer/components/story_viewer_header.dart';
import 'package:ion/app/features/feed/create_story/views/pages/story_viewer_page.dart';

class StoriesSwiper extends HookConsumerWidget {
  const StoriesSwiper({
    required this.users,
    required this.currentUserIndex,
    required this.currentStoryIndex,
    required this.onUserPageChanged,
    required this.onStoryPageChanged,
    required this.onNextStory,
    required this.onPreviousStory,
    super.key,
  });

  final List<UserStories> users;
  final int currentUserIndex;
  final int currentStoryIndex;
  final ValueChanged<int> onUserPageChanged;
  final ValueChanged<int> onStoryPageChanged;
  final VoidCallback onNextStory;
  final VoidCallback onPreviousStory;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userPageController = usePageControllerWithInitialPage(currentUserIndex);

    return CubePageView.builder(
      controller: userPageController,
      itemCount: users.length,
      onPageChanged: onUserPageChanged,
      itemBuilder: (context, userIndex, userNotifier) {
        final user = users[userIndex];
        final isCurrentUser = userIndex == currentUserIndex;

        return CubeWidget(
          index: userIndex,
          pageNotifier: userNotifier,
          child: UserStoryPageView(
            user: user,
            isCurrentUser: isCurrentUser,
            currentStoryIndex: isCurrentUser ? currentStoryIndex : 0,
            onStoryPageChanged: (storyIndex) {
              if (isCurrentUser) {
                onStoryPageChanged(storyIndex);
              }
            },
            onNextStory: onNextStory,
            onPreviousStory: onPreviousStory,
          ),
        );
      },
    );
  }
}

class UserStoryPageView extends HookConsumerWidget {
  const UserStoryPageView({
    required this.user,
    required this.isCurrentUser,
    required this.currentStoryIndex,
    required this.onStoryPageChanged,
    required this.onNextStory,
    required this.onPreviousStory,
    super.key,
  });

  final UserStories user;
  final bool isCurrentUser;
  final int currentStoryIndex;
  final ValueChanged<int> onStoryPageChanged;
  final VoidCallback onNextStory;
  final VoidCallback onPreviousStory;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final storyPageController = usePageControllerWithInitialPage(currentStoryIndex);

    return PageView.builder(
      controller: storyPageController,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: user.stories.length,
      onPageChanged: onStoryPageChanged,
      itemBuilder: (context, storyIndex) {
        final story = user.stories[storyIndex];
        return GestureDetector(
          onTapDown: (details) => _handleTap(context, details.globalPosition.dx, ref),
          child: Stack(
            fit: StackFit.expand,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16.0.s),
                child: StoryViewerContent(story: story),
              ),
              Positioned(
                top: 14.0.s,
                left: 16.0.s,
                right: 22.0.s,
                child: StoryViewerHeader(currentStory: story),
              ),
            ],
          ),
        );
      },
    );
  }

  void _handleTap(BuildContext context, double tapX, WidgetRef ref) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isLeftSide = tapX < screenWidth / 2;

    if (isLeftSide) {
      if (currentStoryIndex > 0) {
        onPreviousStory();
      } else {
        ref.read(storyViewingControllerProvider.notifier).moveToPreviousUser();
      }
    } else {
      if (currentStoryIndex < user.stories.length - 1) {
        onNextStory();
      } else {
        ref.read(storyViewingControllerProvider.notifier).moveToNextUser();
      }
    }
  }
}
