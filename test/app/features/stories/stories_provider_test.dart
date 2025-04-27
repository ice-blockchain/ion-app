// SPDX-License-Identifier: ice License 1.0

import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/core/model/media_type.dart';
import 'package:ion/app/features/core/model/paged.c.dart';
import 'package:ion/app/features/feed/data/models/entities/modifiable_post_data.c.dart';
import 'package:ion/app/features/feed/providers/feed_stories_data_source_provider.c.dart';
import 'package:ion/app/features/feed/stories/providers/stories_provider.c.dart';
import 'package:ion/app/features/ion_connect/model/action_source.c.dart';
import 'package:ion/app/features/ion_connect/model/media_attachment.dart';
import 'package:ion/app/features/ion_connect/providers/entities_paged_data_provider.c.dart';
import 'package:mocktail/mocktail.dart';

import '../../../test_utils.dart';

class _MockPost extends Mock implements ModifiablePostEntity {}

class _FakeMedia extends Fake implements MediaAttachment {
  _FakeMedia(this.mediaType);
  @override
  final MediaType mediaType;

  @override
  String get url => '';

  @override
  int? get duration => null;
}

class _FakePostData extends Fake implements ModifiablePostData {
  _FakePostData(this.mediaType);
  final MediaType mediaType;

  @override
  Map<String, MediaAttachment> get media => {'0': _FakeMedia(mediaType)};
}

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
  final p = _MockPost();
  when(() => p.id).thenReturn(id);
  when(() => p.masterPubkey).thenReturn(author);
  when(() => p.createdAt).thenReturn(createdAt);
  when(() => p.data).thenReturn(_FakePostData(mediaType));
  return p;
}

EntitiesPagedDataState _stateWith(List<ModifiablePostEntity> posts) {
  return EntitiesPagedDataState(
    data: Paged.data(
      posts.toSet(),
      pagination: const <ActionSource, PaginationParams>{},
    ),
  );
}

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
  group('storiesProvider - transformation logic', () {
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
      final result = container.read(storiesProvider)!;

      final keptIds = result.expand((u) => u.stories).map((e) => e.id).toList();
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
      final list = container.read(storiesProvider)!;

      expect(list.length, 3);
      expect(list.map((u) => u.pubkey).toSet(), equals({'alice', 'bob', 'carol'}));
    });
  });
}
