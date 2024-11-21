// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/features/feed/stories/data/models/models.dart';
import 'package:ion/app/features/feed/stories/providers/stories_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'story_viewing_provider.g.dart';

/// A controller for managing story viewing state and navigation in a story viewer interface.
///
/// This controller maintains the state of currently viewed stories and provides methods
/// to navigate between stories and users. It integrates with the [storiesProvider]
/// to access story data.
///
/// Parameters:
/// * [startingPubkey]: Optional public key to initialize the viewer with a specific user's stories
@riverpod
class StoryViewingController extends _$StoryViewingController {
  @override
  StoryViewerState build({String startingPubkey = ''}) {
    final stories = ref.watch(storiesProvider) ?? [];

    var initialUserIndex = (startingPubkey.isNotEmpty)
        ? stories.indexWhere((story) => story.pubkey == startingPubkey)
        : -1;

    initialUserIndex = (initialUserIndex == -1) ? 0 : initialUserIndex;

    return StoryViewerState(
      userStories: stories,
      currentUserIndex: initialUserIndex,
      currentStoryIndex: 0,
    );
  }

  void moveToNextStory() {
    if (state.hasNextStory) {
      state = state.copyWith(
        currentStoryIndex: state.currentStoryIndex + 1,
      );
    } else if (state.hasNextUser) {
      state = state.copyWith(
        currentUserIndex: state.currentUserIndex + 1,
        currentStoryIndex: 0,
      );
    }
  }

  void moveToPreviousStory() {
    if (state.hasPreviousStory) {
      state = state.copyWith(
        currentStoryIndex: state.currentStoryIndex - 1,
      );
    } else if (state.hasPreviousUser) {
      final previousUserStoriesCount =
          state.userStories[state.currentUserIndex - 1].stories.length;
      state = state.copyWith(
        currentUserIndex: state.currentUserIndex - 1,
        currentStoryIndex: previousUserStoriesCount - 1,
      );
    }
  }

  void moveToUser(int userIndex) {
    if (userIndex >= 0 && userIndex < state.userStories.length) {
      state = state.copyWith(
        currentUserIndex: userIndex,
        currentStoryIndex: 0,
      );
    }
  }

  void moveToStoryIndex(int storyIndex) {
    if (storyIndex >= 0 &&
        storyIndex < state.userStories[state.currentUserIndex].stories.length) {
      state = state.copyWith(
        currentStoryIndex: storyIndex,
      );
    }
  }

  void moveToNextUser() {
    if (state.hasNextUser) {
      state = state.copyWith(
        currentUserIndex: state.currentUserIndex + 1,
        currentStoryIndex: 0,
      );
    }
  }

  void moveToStory(int userIndex, int storyIndex) {
    final isValidUser = userIndex >= 0 && userIndex < state.userStories.length;
    final isValidStory = isValidUser &&
        storyIndex >= 0 &&
        storyIndex < state.userStories[userIndex].stories.length;

    if (isValidStory) {
      state = state.copyWith(
        currentUserIndex: userIndex,
        currentStoryIndex: storyIndex,
      );
    }
  }

  void toggleLike(String postId) {
    final updatedUsers = state.userStories.map((user) {
      final updatedPosts = user.stories.map((post) {
        if (post.id == postId) {
          // wait for an event from post to cheсk the like's state when it's ready on the backend
        }
        return post;
      }).toList();

      return user.copyWith(stories: updatedPosts);
    }).toList();

    state = state.copyWith(
      userStories: updatedUsers,
    );
  }
}
