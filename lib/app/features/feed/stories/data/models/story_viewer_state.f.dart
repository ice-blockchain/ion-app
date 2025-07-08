// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/features/feed/stories/data/models/user_story.f.dart';

part 'story_viewer_state.f.freezed.dart';

@freezed
class StoryViewerState with _$StoryViewerState {
  const factory StoryViewerState({
    required List<UserStory> userStories,
    required int currentUserIndex,
    required int currentStoryIndex,
  }) = _StoryViewerState;

  const StoryViewerState._();

  bool get hasPreviousStory => currentStoryIndex > 0;
  bool get hasNextUser => currentUserIndex < userStories.length - 1;
  bool get hasPreviousUser => currentUserIndex > 0;

  UserStory? get currentStory {
    if (userStories.isEmpty) return null;

    return userStories[currentUserIndex];
  }

  String get currentUserPubkey {
    if (userStories.isEmpty) return '';

    return userStories[currentUserIndex].pubkey;
  }
}
