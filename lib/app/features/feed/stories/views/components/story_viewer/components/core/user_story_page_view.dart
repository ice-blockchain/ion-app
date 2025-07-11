// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/progress_bar/ion_loading_indicator.dart';
import 'package:ion/app/features/feed/stories/providers/story_viewing_provider.r.dart';
import 'package:ion/app/features/feed/stories/providers/user_stories_provider.r.dart';
import 'package:ion/app/features/feed/stories/views/components/story_viewer/components/core/story_content.dart';
import 'package:ion/app/features/feed/stories/views/components/story_viewer/components/core/story_gesture_handler.dart';

class UserStoryPageView extends ConsumerWidget {
  const UserStoryPageView({
    required this.isCurrentUser,
    required this.onNextStory,
    required this.onPreviousStory,
    required this.onNextUser,
    required this.onPreviousUser,
    required this.pubkey,
    super.key,
  });

  final bool isCurrentUser;
  final VoidCallback onNextStory;
  final VoidCallback onPreviousStory;
  final VoidCallback onNextUser;
  final VoidCallback onPreviousUser;
  final String pubkey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final storyState = ref.watch(storyViewingControllerProvider(pubkey));
    final stories = ref.watch(userStoriesProvider(storyState.currentUserPubkey))?.toList() ?? [];
    if (stories.isEmpty) {
      return const Center(
        child: IONLoadingIndicator(),
      );
    }
    final currentStory = isCurrentUser ? stories[storyState.currentStoryIndex] : stories.first;

    return KeyboardVisibilityProvider(
      child: StoryGestureHandler(
        key: storyGestureKeyFor(pubkey),
        viewerPubkey: pubkey,
        onTapLeft: () => storyState.currentStoryIndex > 0 ? onPreviousStory() : onPreviousUser(),
        onTapRight: () =>
            storyState.currentStoryIndex < stories.length - 1 ? onNextStory() : onNextUser(),
        child: StoryContent(
          story: currentStory,
          viewerPubkey: pubkey,
        ),
      ),
    );
  }
}
