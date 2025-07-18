// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/features/feed/reposts/models/post_repost.f.dart';
import 'package:ion/app/features/optimistic_ui/core/optimistic_intent.dart';

final class RemoveQuoteIntent implements OptimisticIntent<PostRepost> {
  const RemoveQuoteIntent();

  @override
  PostRepost optimistic(PostRepost current) {
    return current.copyWith(
      quotesCount: current.quotesCount > 0 ? current.quotesCount - 1 : 0,
    );
  }

  @override
  Future<PostRepost> sync(PostRepost prev, PostRepost next) =>
      throw UnimplementedError('Sync is handled by strategy');
}
