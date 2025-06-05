// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/features/feed/stories/data/models/story.c.dart';
import 'package:ion/app/features/feed/stories/providers/feed_stories_provider.c.dart';

class FakeFeedStories extends FeedStories {
  FakeFeedStories(this._stories);

  final Iterable<UserStories> _stories;

  @override
  ({Iterable<UserStories>? items, bool hasMore}) build() {
    return (items: _stories, hasMore: false);
  }
}
