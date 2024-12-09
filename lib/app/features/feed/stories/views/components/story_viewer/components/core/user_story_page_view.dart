// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/feed/stories/data/models/story.c.dart';
import 'package:ion/app/features/feed/stories/providers/story_viewing_provider.c.dart';
import 'package:ion/app/features/feed/stories/views/components/story_viewer/components/core/story_content.dart';
import 'package:ion/app/features/feed/stories/views/components/story_viewer/components/core/story_gesture_handler.dart';

class UserStoryPageView extends ConsumerWidget {
  const UserStoryPageView({
    required this.userStory,
    required this.isCurrentUser,
    required this.onNextStory,
    required this.onPreviousStory,
    required this.onNextUser,
    required this.onPreviousUser,
    super.key,
  });

  final UserStories userStory;
  final bool isCurrentUser;
  final VoidCallback onNextStory;
  final VoidCallback onPreviousStory;
  final VoidCallback onNextUser;
  final VoidCallback onPreviousUser;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final storyState = ref.watch(storyViewingControllerProvider);

    final currentStory =
        isCurrentUser ? userStory.stories[storyState.currentStoryIndex] : userStory.stories[0];

    return KeyboardVisibilityProvider(
      child: StoryGestureHandler(
        onTapLeft: () => storyState.currentStoryIndex > 0 ? onPreviousStory() : onPreviousUser(),
        onTapRight: () => storyState.currentStoryIndex < userStory.stories.length - 1
            ? onNextStory()
            : onNextUser(),
        child: StoryContent(post: currentStory),
      ),
    );
  }
}
