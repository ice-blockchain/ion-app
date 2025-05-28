// SPDX-License-Identifier: ice License 1.0

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
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
  StoryViewerState build(String pubkey, {int initialIndex = 0}) {
    final stories = ref.watch(filteredStoriesByPubkeyProvider(pubkey));

    return StoryViewerState(
      userStories: stories,
      currentUserIndex: 0,
      currentStoryIndex: stories.length > initialIndex ? initialIndex : 0,
    );
  }

  void _moveToNextStory() => state = state.copyWith(currentStoryIndex: state.currentStoryIndex + 1);

  void _moveToPreviousStory() =>
      state = state.copyWith(currentStoryIndex: state.currentStoryIndex - 1);

  void _moveToNextUser() => state = state.copyWith(
        currentUserIndex: state.currentUserIndex + 1,
        currentStoryIndex: 0,
      );

  void _moveToPreviousUser() => state = state.copyWith(
        currentUserIndex: state.currentUserIndex - 1,
        currentStoryIndex: 0,
      );

  /// story → nextStory → nextUser → close
  bool advance({VoidCallback? onClose}) {
    if (state.hasNextStory) {
      _moveToNextStory();
      return true;
    }
    if (state.hasNextUser) {
      _moveToNextUser();
      return true;
    }
    onClose?.call();
    return false;
  }

  /// story ← prevStory ← prevUser ← close
  bool rewind({VoidCallback? onClose}) {
    if (state.hasPreviousStory) {
      _moveToPreviousStory();
      return true;
    }
    if (state.hasPreviousUser) {
      _moveToPreviousUser();
      return true;
    }
    onClose?.call();
    return false;
  }

  void moveToUser(int userIndex) {
    // Do nothing if this is the same author
    if (userIndex == state.currentUserIndex) return;

    if (userIndex >= 0 && userIndex < state.userStories.length) {
      state = state.copyWith(
        currentUserIndex: userIndex,
        currentStoryIndex: 0,
      );
    }
  }

  void toggleLike(String postId) {
    final userStory = state.userStories.firstWhereOrNull((u) => u.getStoryById(postId) != null);
    if (userStory == null) return;

    final post = userStory.getStoryById(postId)!;
    ref.read(toggleLikeNotifierProvider.notifier).toggle(post.toEventReference());
  }
}
