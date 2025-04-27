// SPDX-License-Identifier: ice License 1.0

import 'package:collection/collection.dart';
import 'package:ion/app/features/feed/stories/data/models/models.dart';
import 'package:ion/app/features/feed/stories/providers/stories_provider.c.dart';
import 'package:ion/app/features/optimistic_ui/features/likes/post_like_provider.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'story_viewing_provider.c.g.dart';

/// A controller for managing story viewing state and navigation in a story viewer interface.
///
/// This controller maintains the state of currently viewed stories and provides methods
/// to navigate between stories and users.
@riverpod
class StoryViewingController extends _$StoryViewingController {
  @override
  StoryViewerState build(String pubkey) {
    final userStories = ref.watch(filteredStoriesByPubkeyProvider(pubkey));

    return StoryViewerState(
      userStories: userStories,
      currentUserIndex: 0,
      currentStoryIndex: 0,
    );
  }

  void moveToNextStory() {
    if (state.hasNextStory) {
      state = state.copyWith(currentStoryIndex: state.currentStoryIndex + 1);
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
      final newStoryIndex =
          userIndex > state.currentUserIndex ? 0 : state.userStories[userIndex].stories.length - 1;

      state = state.copyWith(
        currentUserIndex: userIndex,
        currentStoryIndex: newStoryIndex,
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
      final prevUserIndex = state.currentUserIndex - 1;
      final lastStoryIndex = state.userStories[prevUserIndex].stories.length - 1;

      state = state.copyWith(
        currentUserIndex: prevUserIndex,
        currentStoryIndex: lastStoryIndex,
      );
    }
  }

  void toggleLike(String postId) {
    final userStory = state.userStories.firstWhereOrNull(
      (user) => user.getStoryById(postId) != null,
    );

    if (userStory != null) {
      final post = userStory.getStoryById(postId)!;
      final eventReference = post.toEventReference();
      ref.read(toggleLikeNotifierProvider.notifier).toggle(eventReference);
    }
  }
}
