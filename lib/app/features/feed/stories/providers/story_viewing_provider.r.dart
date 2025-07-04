// SPDX-License-Identifier: ice License 1.0

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:ion/app/features/feed/data/models/entities/modifiable_post_data.f.dart';
import 'package:ion/app/features/feed/stories/data/models/models.dart';
import 'package:ion/app/features/feed/stories/providers/feed_stories_provider.r.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.f.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_entity_provider.r.dart';
import 'package:ion/app/features/optimistic_ui/features/likes/post_like_provider.r.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'story_viewing_provider.r.g.dart';

/// A controller for managing story viewing state and navigation in a story viewer interface.
///
/// This controller maintains the state of currently viewed stories and provides methods
/// to navigate between stories and users.
@riverpod
class StoryViewingController extends _$StoryViewingController {
  @override
  StoryViewerState build(String pubkey, {bool showOnlySelectedUser = false}) {
    final stories =
        ref.watch(feedStoriesByPubkeyProvider(pubkey, showOnlySelectedUser: showOnlySelectedUser));

    return StoryViewerState(
      userStories: stories,
      currentUserIndex: 0,
      currentStoryIndex: 0,
    );
  }

  Future<void> setUserStoryByReference(EventReference eventReference) async {
    final storyEntity = await ref.read(
      ionConnectEntityProvider(eventReference: eventReference).future,
    );

    if (storyEntity == null) {
      return;
    }

    state = state.copyWith(
      userStories: [
        UserStories(
          pubkey: pubkey,
          stories: [storyEntity as ModifiablePostEntity],
        ),
      ],
      currentUserIndex: 0,
      currentStoryIndex: 0,
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

  void moveToStory(EventReference storyReference) {
    late final int storyIndex;

    final userIndex = state.userStories.indexWhere(
      (userStory) {
        final index = userStory.getStoryIndexByReference(storyReference);
        if (index != -1) {
          storyIndex = index;
          return true;
        }

        return false;
      },
    );

    if (userIndex == -1) return;

    state = state.copyWith(
      currentUserIndex: userIndex,
      currentStoryIndex: storyIndex,
    );
  }

  void toggleLike(String postId) {
    final userStory = state.userStories.firstWhereOrNull((u) => u.getStoryById(postId) != null);
    if (userStory == null) return;

    final post = userStory.getStoryById(postId)!;
    ref.read(toggleLikeNotifierProvider.notifier).toggle(post.toEventReference());
  }
}
