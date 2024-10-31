// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';

part 'story.freezed.dart';

enum LikeState { liked, notLiked }

enum MuteState { muted, unmuted }

@freezed
class UserStories with _$UserStories {
  const factory UserStories({
    required String userId,
    required String userName,
    required String userAvatar,
    required List<Story> stories,
    @Default(false) bool isVerified,
  }) = _UserStories;

  const UserStories._();
  bool get hasStories => stories.isNotEmpty;
}

@freezed
class StoryData with _$StoryData {
  const factory StoryData({
    required String id,
    required String authorId,
    required String author,
    required String imageUrl,
    required String contentUrl,
    @Default(false) bool nft,
    @Default(false) bool me,
    DateTime? createdAt,
    String? caption,
    @Default(0) int gradientIndex,
    @Default(LikeState.notLiked) LikeState likeState,
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
