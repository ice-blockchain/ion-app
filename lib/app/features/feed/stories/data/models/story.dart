// SPDX-License-Identifier: ice License 1.0

import 'package:collection/collection.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/features/feed/data/models/post_data.dart';

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

  Story? getStoryById(String id) => stories.firstWhereOrNull((story) => story.post.id == id);

  int getStoryIndex(String id) => stories.indexWhere((story) => story.post.id == id);

  bool hasStoryWithId(String id) => stories.any((story) => story.post.id == id);
}

@freezed
sealed class Story with _$Story {
  const factory Story.image({
    required PostEntity post,
    @Default(LikeState.notLiked) LikeState likeState,
  }) = ImageStory;

  const factory Story.video({
    required PostEntity post,
    @Default(MuteState.unmuted) MuteState muteState,
    @Default(LikeState.notLiked) LikeState likeState,
  }) = VideoStory;

  const Story._();

  String get authorId => post.pubkey;
  String get media => post.data.media.values.first.url;
}
