// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/foundation.dart';
import 'package:ion/app/features/feed/data/models/entities/modifiable_post_data.f.dart';
import 'package:ion/app/features/feed/stories/data/models/models.dart';
import 'package:ion/app/features/feed/stories/providers/feed_stories_provider.r.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.f.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_entity_provider.r.dart';
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
        UserStory(
          pubkey: pubkey,
          story: storyEntity as ModifiablePostEntity,
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
  bool advance({required List<ModifiablePostEntity> stories, VoidCallback? onClose}) {
    if (state.currentStoryIndex < stories.length - 1) {
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

  void moveToStoryIndex(int index) {
    if (index == -1) return;

    state = state.copyWith(
      currentStoryIndex: index,
    );
  }
}
