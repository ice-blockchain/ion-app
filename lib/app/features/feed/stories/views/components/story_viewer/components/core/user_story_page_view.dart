// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:ion/app/features/feed/stories/data/models/story.dart';
import 'package:ion/app/features/feed/stories/views/components/story_viewer/components/core/story_content.dart';
import 'package:ion/app/features/feed/stories/views/components/story_viewer/components/core/story_gesture_handler.dart';

class UserStoryPageView extends StatelessWidget {
  const UserStoryPageView({
    required this.userStory,
    required this.isCurrentUser,
    required this.currentStoryIndex,
    required this.onStoryPageChanged,
    required this.onNextStory,
    required this.onPreviousStory,
    required this.onNextUser,
    required this.onPreviousUser,
    super.key,
  });

  final UserStories userStory;
  final bool isCurrentUser;
  final int currentStoryIndex;
  final ValueChanged<int> onStoryPageChanged;
  final VoidCallback onNextStory;
  final VoidCallback onPreviousStory;
  final VoidCallback onNextUser;
  final VoidCallback onPreviousUser;

  @override
  Widget build(BuildContext context) {
    final currentStory = userStory.stories[currentStoryIndex];

    return KeyboardVisibilityProvider(
      child: StoryGestureHandler(
        onTapLeft: () => currentStoryIndex > 0 ? onPreviousStory() : onPreviousUser(),
        onTapRight: () =>
            currentStoryIndex < userStory.stories.length - 1 ? onNextStory() : onNextUser(),
        child: StoryContent(
          post: currentStory,
        ),
      ),
    );
  }
}
