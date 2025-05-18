// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/features/core/model/media_type.dart';
import 'package:ion/app/features/feed/data/models/entities/modifiable_post_data.c.dart';
import 'package:ion/app/features/feed/stories/data/models/story.c.dart';

import '../posts/post_fixtures.dart';

class StoryFixtures {
  StoryFixtures._();

  static const alice = 'alice';
  static const bob = 'bob';
  static const charlie = 'charlie';

  static const videoDurations = (
    quick: Duration(seconds: 1),
    normal: Duration(seconds: 5),
    long: Duration(seconds: 10),
  );

  static UserStories simpleStories({
    required String pubkey,
    int count = 3,
  }) {
    if (count == 0) {
      return UserStories(pubkey: pubkey, stories: []);
    }

    return UserStories(
      pubkey: pubkey,
      stories: List.generate(
        count,
        (i) => buildPost('${pubkey}_story_$i', author: pubkey),
      ),
    );
  }

  static UserStories mixedMediaStories({
    required String pubkey,
    int imageCount = 2,
    int videoCount = 1,
  }) {
    final stories = <ModifiablePostEntity>[];

    for (var i = 0; i < imageCount; i++) {
      stories.add(
        buildPost(
          '${pubkey}_image_$i',
          author: pubkey,
        ),
      );
    }

    for (var i = 0; i < videoCount; i++) {
      stories.add(
        buildPost(
          '${pubkey}_video_$i',
          author: pubkey,
          mediaType: MediaType.video,
        ),
      );
    }

    return UserStories(pubkey: pubkey, stories: stories);
  }

  static List<UserStories> standardViewerSet({
    String viewerPubkey = alice,
    bool includeViewerStories = true,
  }) {
    final stories = <UserStories>[];

    if (includeViewerStories) {
      stories.add(simpleStories(pubkey: viewerPubkey, count: 2));
    }

    stories.addAll([
      simpleStories(pubkey: bob),
      mixedMediaStories(pubkey: charlie),
    ]);

    return stories;
  }

  static UserStories progressTestStories({
    required String pubkey,
    MediaType mediaType = MediaType.image,
  }) {
    return UserStories(
      pubkey: pubkey,
      stories: [
        buildPost('progress_test_1', author: pubkey, mediaType: mediaType),
        buildPost('progress_test_2', author: pubkey, mediaType: mediaType),
      ],
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

extension UserStoriesTestHelpers on UserStories {
  ModifiablePostEntity get firstStory => stories.first;

  ModifiablePostEntity get lastStory => stories.last;

  ModifiablePostEntity storyAt(int index) {
    assert(index >= 0 && index < stories.length, 'Story index out of bounds');
    return stories[index];
  }

  bool get hasVideoStories => stories.any((s) => s.data.primaryMedia?.mediaType == MediaType.video);

  bool get hasImageStories => stories.any((s) => s.data.primaryMedia?.mediaType == MediaType.image);
}
