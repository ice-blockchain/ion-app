// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/features/optimistic_ui/core/optimistic_intent.dart';
import 'package:ion/app/features/optimistic_ui/features/likes/model/post_like.c.dart';

/// Intent to toggle like state for a post.
final class ToggleLikeIntent implements OptimisticIntent<PostLike> {
  @override
  PostLike optimistic(PostLike current) => current.copyWith(
        likedByMe: !current.likedByMe,
        likesCount: current.likesCount + (current.likedByMe ? -1 : 1),
      );

  @override
  Future<PostLike> sync(PostLike prev, PostLike next) =>
      throw UnimplementedError('Sync is handled by strategy');
}
