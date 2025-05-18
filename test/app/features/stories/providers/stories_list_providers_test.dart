// SPDX-License-Identifier: ice License 1.0

import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/core/model/media_type.dart';
import 'package:ion/app/features/core/model/paged.c.dart';
import 'package:ion/app/features/feed/data/models/entities/modifiable_post_data.c.dart';
import 'package:ion/app/features/feed/providers/feed_stories_data_source_provider.c.dart';
import 'package:ion/app/features/feed/stories/data/models/story.c.dart';
import 'package:ion/app/features/feed/stories/providers/stories_provider.c.dart';
import 'package:ion/app/features/ion_connect/model/action_source.c.dart';
import 'package:ion/app/features/ion_connect/providers/entities_paged_data_provider.c.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../fixtures/stories/story_fixtures.dart';
import '../../../../test_utils.dart';

class _FakeEntitiesPagedData extends EntitiesPagedData {
  _FakeEntitiesPagedData(this._state);
  final EntitiesPagedDataState? _state;

  @override
  EntitiesPagedDataState? build(List<EntitiesDataSource>? dataSources) => _state;
}

ModifiablePostEntity _post({
  required String id,
  required String author,
  required MediaType mediaType,
  required DateTime createdAt,
}) {
  final p = buildPost(id, author: author, mediaType: mediaType);
  when(() => p.createdAt).thenReturn(createdAt);
  return p;
}

EntitiesPagedDataState _stateWith(List<ModifiablePostEntity> posts) => EntitiesPagedDataState(
      data: Paged.data(
        posts.toSet(),
        pagination: const <ActionSource, PaginationParams>{},
      ),
    );

ProviderContainer _containerWith(List<ModifiablePostEntity> posts) {
  const dataSources = <EntitiesDataSource>[];
  final fakeState = _stateWith(posts);

  return createContainer(
    overrides: [
      feedStoriesDataSourceProvider.overrideWith((_) => dataSources),
      entitiesPagedDataProvider(dataSources).overrideWith(
        () => _FakeEntitiesPagedData(fakeState),
      ),
    ],
  );
}

void main() {
  setUpAll(registerStoriesFallbacks);

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
      final result = container.read(storiesProvider);

      final keptIds = result?.expand((u) => u.stories).map((e) => e.id).toList();
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
      final aliceStories = container.read(storiesProvider)!.firstWhere((u) => u.pubkey == 'alice');

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
      final list = container.read(storiesProvider);

      expect(list?.length, 3);
      expect(list?.map((u) => u.pubkey).toSet(), equals({'alice', 'bob', 'carol'}));
    });
  });

  group('filteredStoriesByPubkeyProvider', () {
    const alice = 'alice_pub';
    const bob = 'bob_pub';
    const carol = 'carol_pub';

    const dummyStories = [
      UserStories(pubkey: alice, stories: []),
      UserStories(pubkey: bob, stories: []),
      UserStories(pubkey: carol, stories: []),
    ];

    test('returns a list starting with the selected user', () {
      final container = createContainer(
        overrides: [
          storiesProvider.overrideWith((_) => dummyStories),
        ],
      );

      final result = container.read(filteredStoriesByPubkeyProvider(bob));

      expect(result.first.pubkey, equals(bob));
      expect(result.length, equals(2));
    });

    test('returns an empty list if pubkey is not found', () {
      final container = createContainer(
        overrides: [
          storiesProvider.overrideWith((_) => dummyStories),
        ],
      );

      final result = container.read(filteredStoriesByPubkeyProvider('unknown_pubkey'));

      expect(result, isEmpty);
    });
  });
}
