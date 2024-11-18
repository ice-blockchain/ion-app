// SPDX-License-Identifier: ice License 1.0

import 'package:collection/collection.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/features/core/model/media_type.dart';
import 'package:ion/app/features/feed/data/models/post_data.dart';
import 'package:ion/app/features/user/model/user_metadata.dart';

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

  factory UserStories.fromPosts(
    String userId,
    List<PostEntity> posts,
    UserMetadata? userMetadata,
  ) {
    final stories = posts
        .map<Story?>((post) => Story.fromPostEntity(post, userMetadata))
        .whereType<Story>()
        .toList();

    return UserStories(
      userId: userId,
      userName: userMetadata?.displayName ?? '',
      userAvatar: userMetadata?.picture ?? '',
      stories: stories,
      isVerified: userMetadata?.verified ?? false,
    );
  }

  bool get hasStories => stories.isNotEmpty;

  Story? getStoryById(String id) => stories.firstWhereOrNull((story) => story.data.id == id);

  int getStoryIndex(String id) => stories.indexWhere((story) => story.data.id == id);

  bool hasStoryWithId(String id) => stories.any((story) => story.data.id == id);
}

@freezed
class StoryData with _$StoryData {
  const factory StoryData({
    required String id,
    required String authorId,
    required String author,
    // required String imageUrl,
    // required String contentUrl,
    required String mediaUrl,
    @Default(false) bool nft,
    @Default(false) bool me,
    DateTime? createdAt,
    String? caption,
    @Default(0) int gradientIndex,
    @Default(LikeState.notLiked) LikeState likeState,
  }) = _StoryData;

  factory StoryData.fromPostEntity(PostEntity postEntity, UserMetadata? userMetadata) {
    final mediaAttachment = postEntity.data.media.values.first;
    return StoryData(
      id: postEntity.id,
      authorId: postEntity.pubkey,
      author: userMetadata?.displayName ?? '',
      mediaUrl: mediaAttachment.url,
      createdAt: postEntity.createdAt,
    );
  }
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

  const Story._();

  factory Story.fromPostEntity(PostEntity postEntity, UserMetadata? userMetadata) {
    final mediaAttachment = postEntity.data.media.values.firstOrNull;

    if (mediaAttachment == null) {
      throw Exception('PostEntity does not have any media attachments');
    }

    final storyData = StoryData(
      id: postEntity.id,
      authorId: postEntity.pubkey,
      author: userMetadata?.displayName ?? 'Unknown',
      mediaUrl: mediaAttachment.url,
      createdAt: postEntity.createdAt,
    );

    return switch (mediaAttachment.mediaType) {
      MediaType.image => Story.image(data: storyData),
      MediaType.video => Story.video(data: storyData),
      _ => throw UnsupportedError('Media type not supported for stories')
    };
  }

  String get authorId => data.authorId;
  String get mediaUrl => data.mediaUrl;
}
