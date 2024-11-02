// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/features/feed/stories/data/models/story.dart';

part 'story_viewer_state.freezed.dart';

@freezed
sealed class StoryViewerState with _$StoryViewerState {
  const factory StoryViewerState.initial() = _StoryViewerStateInitial;
  const factory StoryViewerState.loading() = _StoryViewerStateLoading;
  const factory StoryViewerState.ready({
    required List<UserStories> users,
    required int currentUserIndex,
    required int currentStoryIndex,
  }) = _StoryViewerStateReady;
  const factory StoryViewerState.error({
    required String message,
  }) = _StoryViewerStateError;

  const StoryViewerState._();

  bool get hasNextStory =>
      whenOrNull(
        ready: (users, userIndex, storyIndex) => storyIndex < users[userIndex].stories.length - 1,
      ) ??
      false;

  bool get hasPreviousStory =>
      whenOrNull(
        ready: (_, __, storyIndex) => storyIndex > 0,
      ) ??
      false;

  bool get hasNextUser =>
      whenOrNull(
        ready: (users, userIndex, _) => userIndex < users.length - 1,
      ) ??
      false;

  bool get hasPreviousUser =>
      whenOrNull(
        ready: (_, userIndex, __) => userIndex > 0,
      ) ??
      false;

  Story? get currentStory => whenOrNull(
        ready: (users, userIndex, storyIndex) => users[userIndex].stories[storyIndex],
      );

  UserStories? get currentUser => whenOrNull(
        ready: (users, userIndex, _) => users[userIndex],
      );
}
