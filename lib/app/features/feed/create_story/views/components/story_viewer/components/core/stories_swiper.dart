// SPDX-License-Identifier: ice License 1.0

import 'package:cube_transition_plus/cube_transition_plus.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ion/app/features/feed/create_story/data/models/story.dart';
import 'package:ion/app/features/feed/create_story/views/components/story_viewer/components/core/core.dart';

class StoriesSwiper extends StatelessWidget {
  const StoriesSwiper({
    required this.userPageController,
    required this.users,
    required this.currentUserIndex,
    required this.currentStoryIndex,
    required this.onUserPageChanged,
    required this.onStoryPageChanged,
    required this.onNextStory,
    required this.onPreviousStory,
    super.key,
  });

  final PageController userPageController;
  final List<UserStories> users;
  final int currentUserIndex;
  final int currentStoryIndex;
  final ValueChanged<int> onUserPageChanged;
  final ValueChanged<int> onStoryPageChanged;
  final VoidCallback onNextStory;
  final VoidCallback onPreviousStory;

  @override
  Widget build(BuildContext context) {
    return CubePageView.builder(
      controller: userPageController,
      itemCount: users.length,
      onPageChanged: (index) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          onUserPageChanged(index);
        });
      },
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
            onNextUser: () {
              final hasNextUser = userPageController.hasClients && userIndex < users.length - 1;

              if (hasNextUser) {
                userPageController.nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              } else {
                context.pop();
              }
            },
            onPreviousUser: () {
              final hasPreviousUser = userPageController.hasClients && userIndex > 0;

              if (hasPreviousUser) {
                userPageController.previousPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              } else {
                context.pop();
              }
            },
          ),
        );
      },
    );
  }
}
