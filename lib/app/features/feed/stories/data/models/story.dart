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
    required String pubkey,
    required List<PostEntity> stories,
  }) = _UserStories;

  const UserStories._();

  bool get hasStories => stories.isNotEmpty;

  PostEntity? getStoryById(String id) => stories.firstWhereOrNull((post) => post.id == id);

  int getStoryIndex(String id) => stories.indexWhere((post) => post.id == id);

  bool hasStoryWithId(String id) => stories.any((post) => post.id == id);
}
