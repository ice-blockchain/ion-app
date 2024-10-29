// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/features/feed/create_story/data/models/story.dart';

part 'story_viewer_state.freezed.dart';

@freezed
sealed class StoryViewerState with _$StoryViewerState {
  const factory StoryViewerState.initial() = _StoryViewerStateInitial;
  const factory StoryViewerState.loading() = _StoryViewerStateLoading;
  const factory StoryViewerState.ready({
    required List<Story> stories,
    required int currentIndex,
  }) = _StoryViewerStateReady;
  const factory StoryViewerState.error({
    required String message,
  }) = _StoryViewerStateError;
}
