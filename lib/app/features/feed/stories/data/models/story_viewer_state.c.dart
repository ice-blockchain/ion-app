// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/features/feed/data/models/entities/modifiable_post_data.c.dart';
import 'package:ion/app/features/feed/stories/data/models/story.c.dart';

part 'story_viewer_state.c.freezed.dart';

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

  ModifiablePostEntity? get currentStory {
    if (userStories.isEmpty) return null;

    final currentUserStories = userStories[currentUserIndex];

    if (currentUserStories.stories.isEmpty ||
        currentStoryIndex < 0 ||
        currentStoryIndex >= currentUserStories.stories.length) {
      return null;
    }

    return currentUserStories.stories[currentStoryIndex];
  }

  UserStories? get currentUser => userStories[currentUserIndex];
}
