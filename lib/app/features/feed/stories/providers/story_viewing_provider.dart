// SPDX-License-Identifier: ice License 1.0

import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:ion/app/extensions/object.dart';
import 'package:ion/app/features/feed/stories/data/models/models.dart';
import 'package:ion/app/features/feed/stories/providers/stories_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'story_viewing_provider.g.dart';

/// A controller for managing story viewing state and navigation in a story viewer interface.
///
/// This controller maintains the state of currently viewed stories and provides methods
/// to navigate between stories and users.
@riverpod
class StoryViewingController extends _$StoryViewingController {
  @override
  StoryViewerState build({required String startingPubkey}) {
    final stories = ref.watch(storiesProvider);

    const emptyState = StoryViewerState(
      userStories: [],
      currentUserIndex: 0,
      currentStoryIndex: 0,
    );

    log('Stories count: ${stories?.length}', name: 'StoryViewingController');

    log('starting pubkey: $startingPubkey', name: 'StoryViewingController');

    final result = stories?.firstWhereOrNull((UserStories userStories) {
          return userStories.pubkey == startingPubkey;
        })?.let<StoryViewerState>(
          (UserStories foundStories) {
            log(
              'Stories count: ${stories.length}, Found index: ${stories.indexOf(foundStories)}',
              name: 'StoryViewingController',
            );
            return StoryViewerState(
              userStories: stories,
              currentUserIndex: stories.indexOf(foundStories),
              currentStoryIndex: 0,
            );
          },
        ) ??
        emptyState;

    return result;
  }

  void moveToNextStory() {
    if (state.hasNextStory) {
      state = state.copyWith(
        currentStoryIndex: state.currentStoryIndex + 1,
      );
    } else {
      moveToNextUser();
    }
  }

  void moveToPreviousStory() {
    if (state.hasPreviousStory) {
      state = state.copyWith(
        currentStoryIndex: state.currentStoryIndex - 1,
      );
    } else {
      moveToPreviousUser();
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
    if (storyIndex >= 0 && storyIndex < state.userStories[state.currentUserIndex].stories.length) {
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

  void moveToPreviousUser() {
    if (state.hasPreviousUser) {
      state = state.copyWith(
        currentUserIndex: state.currentUserIndex - 1,
        currentStoryIndex: 0,
      );
    }
  }

  void moveToStory(int userIndex, int storyIndex) {
    final isValidUser = userIndex >= 0 && userIndex < state.userStories.length;
    final isValidStory =
        isValidUser && storyIndex >= 0 && storyIndex < state.userStories[userIndex].stories.length;

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
