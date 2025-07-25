// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/features/feed/reposts/models/post_repost.f.dart';
import 'package:ion/app/features/optimistic_ui/core/optimistic_intent.dart';

/// Intent to toggle repost state for a post.
final class ToggleRepostIntent implements OptimisticIntent<PostRepost> {
  const ToggleRepostIntent();

  @override
  PostRepost optimistic(PostRepost current) {
    if (current.repostedByMe) {
      // Remove repost
      return current.copyWith(
        repostedByMe: false,
        repostsCount: current.repostsCount > 0 ? current.repostsCount - 1 : 0,
        myRepostReference: null,
      );
    } else {
      // Add repost
      return current.copyWith(
        repostedByMe: true,
        repostsCount: current.repostsCount + 1,
      );
    }
  }

  @override
  Future<PostRepost> sync(PostRepost prev, PostRepost next) =>
      throw UnimplementedError('Sync is handled by strategy');
}
