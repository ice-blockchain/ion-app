// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/feed/stories/data/models/story.dart';
import 'package:ion/app/features/feed/stories/views/components/story_viewer/components/core/story_content.dart';
import 'package:ion/app/features/feed/stories/views/components/story_viewer/components/core/story_gesture_handler.dart';

class UserStoryPageView extends HookConsumerWidget {
  const UserStoryPageView({
    required this.user,
    required this.isCurrentUser,
    required this.currentStoryIndex,
    required this.onStoryPageChanged,
    required this.onNextStory,
    required this.onPreviousStory,
    required this.onNextUser,
    required this.onPreviousUser,
    required this.onPausedChanged,
    super.key,
  });

  final UserStories user;
  final bool isCurrentUser;
  final int currentStoryIndex;
  final ValueChanged<int> onStoryPageChanged;
  final VoidCallback onNextStory;
  final VoidCallback onPreviousStory;
  final VoidCallback onNextUser;
  final VoidCallback onPreviousUser;
  final ValueChanged<bool> onPausedChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentStory = user.stories[currentStoryIndex];
    final isPaused = useState(false);

    final previousIsPaused = usePrevious(isPaused.value);

    useEffect(
      () {
        if (isPaused.value != previousIsPaused) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            onPausedChanged(isPaused.value);
          });
        }
        return null;
      },
      [isPaused.value],
    );

    return StoryGestureHandler(
      onTapLeft: () => currentStoryIndex > 0 ? onPreviousStory() : onPreviousUser(),
      onTapRight: () => currentStoryIndex < user.stories.length - 1 ? onNextStory() : onNextUser(),
      onLongPressStart: () => isPaused.value = true,
      onLongPressEnd: () => isPaused.value = false,
      child: StoryContent(
        story: currentStory,
        isPaused: isPaused.value,
      ),
    );
  }
}
