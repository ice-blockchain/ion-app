// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/features/core/model/media_type.dart';
import 'package:ion/app/features/feed/stories/data/models/story.c.dart';

import '../posts/post_fixtures.dart';

class StoryFixtures {
  StoryFixtures._();

  static const alice = 'alice';
  static const bob = 'bob';
  static const charlie = 'charlie';

  static UserStories simpleStories({
    required String pubkey,
    int count = 3,
    MediaType mediaType = MediaType.image,
  }) {
    if (count == 0) {
      return UserStories(pubkey: pubkey, stories: []);
    }

    return UserStories(
      pubkey: pubkey,
      stories: List.generate(
        count,
        (i) => buildPost('${pubkey}_story_$i', author: pubkey, mediaType: mediaType),
      ),
    );
  }

  static UserStories singleStory({
    String pubkey = alice,
    MediaType mediaType = MediaType.image,
  }) {
    return UserStories(
      pubkey: pubkey,
      stories: [
        buildPost('single_story', author: pubkey, mediaType: mediaType),
      ],
    );
  }
}
