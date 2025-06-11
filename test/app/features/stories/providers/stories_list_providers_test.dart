// SPDX-License-Identifier: ice License 1.0

import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/core/model/media_type.dart';
import 'package:ion/app/features/feed/data/models/entities/modifiable_post_data.c.dart';
import 'package:ion/app/features/feed/data/models/feed_modifier.dart';
import 'package:ion/app/features/feed/data/models/feed_type.dart';
import 'package:ion/app/features/feed/providers/feed_for_you_content_provider.c.dart';
import 'package:ion/app/features/feed/stories/providers/feed_stories_provider.c.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../fixtures/posts/post_fixtures.dart';
import '../../../../fixtures/stories/story_fixtures.dart';
import '../../../../test_utils.dart';
import '../data/fake_feed_stories_state.dart';

class _FakeFeedForYouContent extends FeedForYouContent {
  _FakeFeedForYouContent(this._state);
  final FeedForYouContentState _state;

  @override
  FeedForYouContentState build(
    FeedType feedType, {
    FeedModifier? feedModifier,
    bool showSeen = true,
  }) =>
      _state;
}

ModifiablePostEntity _post({
  required String id,
  required String author,
  required MediaType mediaType,
  required DateTime createdAt,
}) {
  final post = buildPost(id, author: author, mediaType: mediaType);
  when(() => post.createdAt).thenReturn(createdAt.microsecondsSinceEpoch);
  return post;
}

FeedForYouContentState _stateWith(List<ModifiablePostEntity> posts) => FeedForYouContentState(
      items: posts.toSet(),
      relaysPagination: {},
      isLoading: false,
    );

ProviderContainer _containerWith(List<ModifiablePostEntity> posts) {
  return createContainer(
    overrides: [
      feedForYouContentProvider(FeedType.story).overrideWith(
        () => _FakeFeedForYouContent(_stateWith(posts)),
      ),
    ],
  );
}

void main() {
  group('storiesProvider – transformation logic', () {
    test('filters out posts with non-image/video media', () {
      final posts = [
        _post(
          id: 'image_1',
          author: 'alice',
          mediaType: MediaType.image,
          createdAt: DateTime(2024),
        ),
        _post(
          id: 'audio_ignored',
          author: 'bob',
          mediaType: MediaType.audio,
          createdAt: DateTime(2024),
        ),
        _post(
          id: 'video_1',
          author: 'bob',
          mediaType: MediaType.video,
          createdAt: DateTime(2024, 1, 2),
        ),
      ];

      final container = _containerWith(posts);
      final result = container.read(feedStoriesProvider);

      final keptIds = result.items?.expand((u) => u.stories).map((e) => e.id).toList();
      expect(keptIds, unorderedEquals(['image_1', 'video_1']));
    });

    test('each UserStories list is sorted by createdAt asc', () {
      final posts = [
        _post(
          id: 'late',
          author: 'alice',
          mediaType: MediaType.image,
          createdAt: DateTime(2024, 6, 2),
        ),
        _post(
          id: 'early',
          author: 'alice',
          mediaType: MediaType.image,
          createdAt: DateTime(2024, 6),
        ),
      ];

      final container = _containerWith(posts);
      final aliceStories =
          container.read(feedStoriesProvider).items!.firstWhere((u) => u.pubkey == 'alice');

      final orderedIds = aliceStories.stories.map((e) => e.id).toList();
      expect(orderedIds, equals(['early', 'late']));
    });

    test('returns N UserStories for N distinct authors', () {
      final posts = [
        _post(
          id: 'p1',
          author: 'alice',
          mediaType: MediaType.image,
          createdAt: DateTime(2024),
        ),
        _post(
          id: 'p2',
          author: 'bob',
          mediaType: MediaType.video,
          createdAt: DateTime(2024),
        ),
        _post(
          id: 'p3',
          author: 'carol',
          mediaType: MediaType.image,
          createdAt: DateTime(2024),
        ),
      ];

      final container = _containerWith(posts);
      final list = container.read(feedStoriesProvider).items;

      expect(list?.length, 3);
      expect(list?.map((u) => u.pubkey).toSet(), equals({'alice', 'bob', 'carol'}));
    });
  });

  group('filteredStoriesByPubkeyProvider', () {
    const alice = 'alice_pub';
    const bob = 'bob_pub';
    const carol = 'carol_pub';

    final dummyStories = [
      StoryFixtures.simpleStories(pubkey: alice, count: 0),
      StoryFixtures.simpleStories(pubkey: bob, count: 0),
      StoryFixtures.simpleStories(pubkey: carol, count: 0),
    ];

    test('returns a list starting with the selected user', () {
      final container = createContainer(
        overrides: [
          feedStoriesProvider.overrideWith(() => FakeFeedStories(dummyStories)),
        ],
      );

      final result = container.read(feedStoriesByPubkeyProvider(bob));

      expect(result.first.pubkey, equals(bob));
      expect(result.length, equals(2));
    });

    test('returns an empty list if pubkey is not found', () {
      final container = createContainer(
        overrides: [
          feedStoriesProvider.overrideWith(() => FakeFeedStories(dummyStories)),
        ],
      );

      final result = container.read(feedStoriesByPubkeyProvider('unknown_pubkey'));

      expect(result, isEmpty);
    });
  });
}
