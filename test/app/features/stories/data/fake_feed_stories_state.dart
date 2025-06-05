// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/features/feed/stories/data/models/story.c.dart';
import 'package:ion/app/features/feed/stories/providers/feed_stories_provider.c.dart';

class FakeFeedStories extends FeedStories {
  FakeFeedStories(this.stories);

  // ignore: avoid_public_notifier_properties
  final Iterable<UserStories> stories;

  @override
  ({Iterable<UserStories>? items, bool hasMore}) build() {
    return (items: stories, hasMore: false);
  }
}
