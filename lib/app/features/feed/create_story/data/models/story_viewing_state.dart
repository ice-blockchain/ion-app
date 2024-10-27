// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/features/feed/create_story/data/models/story.dart';

part 'story_viewing_state.freezed.dart';

@freezed
sealed class StoryViewingState with _$StoryViewingState {
  const factory StoryViewingState.initial() = _StoryViewingStateInitial;
  const factory StoryViewingState.loading() = _StoryViewingStateLoading;
  const factory StoryViewingState.ready({
    required List<Story> stories,
    required int currentIndex,
  }) = _StoryViewingStateReady;
  const factory StoryViewingState.error({
    required String message,
  }) = _StoryViewingStateError;
}
