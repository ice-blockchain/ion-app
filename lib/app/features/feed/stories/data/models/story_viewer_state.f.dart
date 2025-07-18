// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/features/feed/stories/data/models/user_story.f.dart';

part 'story_viewer_state.f.freezed.dart';

@freezed
class SingleUserStoriesViewerState with _$SingleUserStoriesViewerState {
  const factory SingleUserStoriesViewerState({
    required String pubkey,
    required int currentStoryIndex,
  }) = _SingleUserStoriesViewerState;

  const SingleUserStoriesViewerState._();

  bool get hasPreviousStory => currentStoryIndex > 0;
}

@freezed
class UserStoriesViewerState with _$UserStoriesViewerState {
  const factory UserStoriesViewerState({
    required List<UserStory> userStories,
    required int currentUserIndex,
  }) = _UserStoriesViewerState;

  const UserStoriesViewerState._();

  bool get hasNextUser => currentUserIndex < userStories.length - 1;
  bool get hasPreviousUser => currentUserIndex > 0;

  UserStory? get currentStory {
    if (userStories.isEmpty) return null;

    return userStories.elementAtOrNull(currentUserIndex);
  }

  String get currentUserPubkey {
    if (userStories.isEmpty) return '';

    return userStories[currentUserIndex].pubkey;
  }

  String get nextUserPubkey {
    return pubkeyAtIndex(currentUserIndex + 1);
  }

  String pubkeyAtIndex(int index) {
    return userStories.elementAtOrNull(index)?.pubkey ?? '';
  }
}
