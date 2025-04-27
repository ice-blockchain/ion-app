// SPDX-License-Identifier: ice License 1.0

import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/feed/stories/providers/viewed_stories_provider.c.dart';
import 'package:ion/app/services/storage/local_storage.c.dart';
import 'package:ion/app/services/storage/user_preferences_service.c.dart';
import 'package:mocktail/mocktail.dart';

import '../../../mocks.dart';
import '../../../test_utils.dart';

void main() {
  const identity = 'user1';
  const keyPrefix = 'user_$identity:';
  const prefKey = '${keyPrefix}viewedStories';

  late MockLocalStorage mockStorage;

  setUp(() {
    mockStorage = MockLocalStorage();

    when(() => mockStorage.setStringList(any(), any<List<String>>())).thenAnswer((_) async => true);
  });

  ProviderContainer buildContainer({List<String>? initialIds}) {
    when(() => mockStorage.getStringList(prefKey)).thenReturn(initialIds);

    return createContainer(
      overrides: [
        currentIdentityKeyNameSelectorProvider.overrideWith((_) => identity),
        localStorageProvider.overrideWithValue(mockStorage),
        userPreferencesServiceProvider(identityKeyName: identity).overrideWith(
          (_) => UserPreferencesService(identity, mockStorage),
        ),
      ],
    );
  }

  group('ViewedStoriesController', () {
    test('build() reads saved Set<String> from preferences', () {
      final container = buildContainer(initialIds: ['s1', 's2']);

      final state = container.read(viewedStoriesControllerProvider);

      expect(state, equals({'s1', 's2'}));
      verify(() => mockStorage.getStringList(prefKey)).called(1);
    });

    test('markStoryAsViewed() persists only on first insert', () async {
      final container = buildContainer(initialIds: []);

      final notifier = container.read(viewedStoriesControllerProvider.notifier);

      // first time – should save
      await notifier.markStoryAsViewed('storyX');
      expect(container.read(viewedStoriesControllerProvider), contains('storyX'));
      verify(() => mockStorage.setStringList(prefKey, ['storyX'])).called(1);

      // second time with same ID – no extra save
      await notifier.markStoryAsViewed('storyX');
      verifyNever(() => mockStorage.setStringList(prefKey, ['storyX', 'storyX']));
    });

    test('syncAvailableStories() removes stale IDs and persists once', () async {
      final container = buildContainer(initialIds: ['a', 'b', 'c']);

      final notifier = container.read(viewedStoriesControllerProvider.notifier);

      // first sync – persists once
      await notifier.syncAvailableStories(['a', 'c']);
      verify(() => mockStorage.setStringList(prefKey, ['a', 'c'])).called(1);

      clearInteractions(mockStorage);

      await notifier.syncAvailableStories(['a', 'c']);
      verifyNever(() => mockStorage.setStringList(any(), any()));
    });
  });
}
