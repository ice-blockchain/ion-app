import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/core/providers/video_player_provider.dart';
import 'package:ion/app/features/feed/create_story/data/models/story.dart';
import 'package:ion/app/features/feed/create_story/providers/story_viewing_provider.dart';
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
    final currentStory = user.stories[currentStoryIndex];
    final isVideoPlaying = currentStory is VideoStory;

    return StoryGestureHandler(
      onTapLeft: () {
        if (currentStoryIndex > 0) {
          onPreviousStory();
        } else {
          ref.read(storyViewingControllerProvider.notifier).moveToPreviousUser();
        }
      },
      onTapRight: () {
        if (currentStoryIndex < user.stories.length - 1) {
          onNextStory();
        } else {
          ref.read(storyViewingControllerProvider.notifier).moveToNextUser();
        }
      },
      onLongPressStart: () {
        if (isVideoPlaying) {
          ref.read(videoControllerProvider(currentStory.data.contentUrl)).pause();
        }
      },
      onLongPressEnd: () {
        if (isVideoPlaying) {
          ref.read(videoControllerProvider(currentStory.data.contentUrl)).play();
        }
      },
      child: StoryContent(
        story: currentStory,
        isVideoPlaying: isVideoPlaying,
      ),
    );
  }
}
