// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';

part 'story.freezed.dart';

enum LikeState { liked, notLiked }

enum MuteState { muted, unmuted }

@freezed
class ProgressState with _$ProgressState {
  const factory ProgressState.inProgress(double value) = _InProgress;
  const factory ProgressState.completed() = _Completed;
  const factory ProgressState.notStarted() = _NotStarted;
}

@freezed
class StoryData with _$StoryData {
  const factory StoryData({
    required String id,
    required String imageUrl,
    required String contentUrl,
    required String author,
    DateTime? createdAt,
    String? caption,
    @Default(false) bool nft,
    @Default(false) bool me,
    @Default(0) int gradientIndex,
    @Default(LikeState.notLiked) LikeState likeState,
    @Default(ProgressState.notStarted()) ProgressState progressState,
  }) = _StoryData;
}

@freezed
sealed class Story with _$Story {
  const factory Story.image({
    required StoryData data,
  }) = ImageStory;

  const factory Story.video({
    required StoryData data,
    @Default(MuteState.unmuted) MuteState muteState,
  }) = VideoStory;
}
