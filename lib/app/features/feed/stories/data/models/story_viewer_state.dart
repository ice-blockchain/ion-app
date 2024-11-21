// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/features/feed/data/models/post_data.dart';
import 'package:ion/app/features/feed/stories/data/models/story.dart';

part 'story_viewer_state.freezed.dart';

@freezed
class StoryViewerState with _$StoryViewerState {
  const factory StoryViewerState({
    required List<UserStories> userStories,
    required int currentUserIndex,
    required int currentStoryIndex,
  }) = _StoryViewerState;

  const StoryViewerState._();

  bool get hasNextStory => currentStoryIndex < userStories[currentUserIndex].stories.length - 1;
  bool get hasPreviousStory => currentStoryIndex > 0;
  bool get hasNextUser => currentUserIndex < userStories.length - 1;
  bool get hasPreviousUser => currentUserIndex > 0;

  PostEntity? get currentStory => userStories[currentUserIndex].stories[currentStoryIndex];
  UserStories? get currentUser => userStories[currentUserIndex];
}
