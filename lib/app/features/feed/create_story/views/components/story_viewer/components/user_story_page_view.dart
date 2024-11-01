import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/core/providers/video_player_provider.dart';
import 'package:ion/app/features/feed/create_story/data/models/story.dart';
import 'package:ion/app/features/feed/create_story/views/components/story_viewer/components/story_content.dart';
import 'package:ion/app/features/feed/create_story/views/components/story_viewer/components/story_gesture_handler.dart';

class UserStoryPageView extends ConsumerWidget {
  const UserStoryPageView({
    required this.user,
    required this.isCurrentUser,
    required this.currentStoryIndex,
    required this.onStoryPageChanged,
    required this.onNextStory,
    required this.onPreviousStory,
    required this.onNextUser,
    required this.onPreviousUser,
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentStory = user.stories[currentStoryIndex];
    final isVideoPlaying = currentStory is VideoStory;

    return StoryGestureHandler(
      onTapLeft: () => currentStoryIndex > 0 ? onPreviousStory() : onPreviousUser(),
      onTapRight: () => currentStoryIndex < user.stories.length - 1 ? onNextStory() : onNextUser(),
      onLongPressStart: () => isVideoPlaying
          ? ref.read(videoControllerProvider(currentStory.data.contentUrl)).pause()
          : null,
      onLongPressEnd: () => isVideoPlaying
          ? ref.read(videoControllerProvider(currentStory.data.contentUrl)).play()
          : null,
      child: StoryContent(
        story: currentStory,
        isVideoPlaying: isVideoPlaying,
      ),
    );
  }
}
