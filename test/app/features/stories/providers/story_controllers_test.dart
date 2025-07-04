// SPDX-License-Identifier: ice License 1.0

import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/auth/providers/auth_provider.m.dart';
import 'package:ion/app/features/feed/stories/providers/feed_stories_provider.r.dart';
import 'package:ion/app/features/feed/stories/providers/story_viewing_provider.r.dart';
import 'package:ion/app/features/feed/stories/providers/viewed_stories_provider.r.dart';
import 'package:ion/app/services/storage/local_storage.r.dart';
import 'package:ion/app/services/storage/user_preferences_service.r.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../fixtures/stories/story_fixtures.dart';
import '../../../../mocks.dart';
import '../../../../test_utils.dart';
import '../data/fake_feed_stories_state.dart';

void main() {
  const alice = StoryFixtures.alice;
  const bob = StoryFixtures.bob;

  final aliceUserStories = StoryFixtures.simpleStories(
    pubkey: alice,
    count: 2,
  );
  final bobUserStories = StoryFixtures.simpleStories(
    pubkey: bob,
    count: 1,
  );

  final overrides = [
    feedStoriesProvider.overrideWith(
      () => FakeFeedStories([aliceUserStories, bobUserStories]),
    ),
  ];

  group('StoryViewingController navigation', () {
    test('initial state starts at user 0, story 0', () {
      final container = createContainer(overrides: overrides);
      final state = container.read(storyViewingControllerProvider(alice));

      expect(state.currentUserIndex, 0);
      expect(state.currentStoryIndex, 0);
    });

    test('advance increments story index within the same user', () {
      final container = createContainer(overrides: overrides);

      container.read(storyViewingControllerProvider(alice).notifier).advance(); // a2

      final state = container.read(storyViewingControllerProvider(alice));

      expect(state.currentUserIndex, 0);
      expect(state.currentStoryIndex, 1);
    });

    test('advance on last story jumps to next user (story 0)', () {
      final container = createContainer(overrides: overrides);

      container.read(storyViewingControllerProvider(alice).notifier)
        ..advance() // a2
        ..advance(); // bob/b1

      final state = container.read(storyViewingControllerProvider(alice));

      expect(state.currentUserIndex, 1);
      expect(state.currentStoryIndex, 0);
    });

    test('rewind at first story jumps to previous user (story 0)', () {
      final container = createContainer(overrides: overrides);

      container.read(storyViewingControllerProvider(alice).notifier)
        ..advance() // a2
        ..advance() // bob/b1
        ..rewind(); // back to Alice/a1

      final state = container.read(storyViewingControllerProvider(alice));

      expect(state.currentUserIndex, 0);
      expect(state.currentStoryIndex, 0);
    });

    test('moveToUser always resets story index to 0', () {
      final container = createContainer(overrides: overrides);
      final notifier = container.read(storyViewingControllerProvider(alice).notifier)
        ..moveToUser(1); // Bob
      var state = container.read(storyViewingControllerProvider(alice));
      expect(state.currentUserIndex, 1);
      expect(state.currentStoryIndex, 0);

      notifier.moveToUser(0); // Alice
      state = container.read(storyViewingControllerProvider(alice));
      expect(state.currentUserIndex, 0);
      expect(state.currentStoryIndex, 0);
    });

    test(
      'advance does not overwrite indices when moveToUser is called '
      'with the current user (CubePageView onPageChanged)',
      () {
        final container = createContainer(overrides: overrides);
        final notifier = container.read(storyViewingControllerProvider(alice).notifier)..advance();

        var state = container.read(storyViewingControllerProvider(alice));
        expect(state.currentUserIndex, 0);
        expect(state.currentStoryIndex, 1);

        notifier.moveToUser(state.currentUserIndex);

        state = container.read(storyViewingControllerProvider(alice));
        expect(state.currentUserIndex, 0);
        expect(state.currentStoryIndex, 1);
      },
    );
  });

  group('ViewedStoriesController', () {
    const identity = 'user1';
    const keyPrefix = 'user_$identity:';
    const prefKey = '${keyPrefix}viewedStories';

    late MockLocalStorage mockStorage;

    setUp(() {
      mockStorage = MockLocalStorage();
      when(() => mockStorage.setStringList(any(), any<List<String>>()))
          .thenAnswer((_) async => true);
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

    test('build() reads saved Set<String> from preferences', () {
      final container = buildContainer(initialIds: ['s1', 's2']);

      final state = container.read(viewedStoriesControllerProvider);

      expect(state, equals({'s1', 's2'}));
      verify(() => mockStorage.getStringList(prefKey)).called(1);
    });

    test('markStoryAsViewed() persists only on first insert', () async {
      final container = buildContainer(initialIds: []);

      final notifier = container.read(viewedStoriesControllerProvider.notifier);

      await notifier.markStoryAsViewed('storyX');
      expect(
        container.read(viewedStoriesControllerProvider),
        contains('storyX'),
      );
      verify(() => mockStorage.setStringList(prefKey, ['storyX'])).called(1);

      await notifier.markStoryAsViewed('storyX');
      verifyNever(
        () => mockStorage.setStringList(prefKey, ['storyX', 'storyX']),
      );
    });

    test('syncAvailableStories() removes stale IDs and persists once', () async {
      final container = buildContainer(initialIds: ['a', 'b', 'c']);

      final notifier = container.read(viewedStoriesControllerProvider.notifier);

      await notifier.syncAvailableStories(['a', 'c']);
      verify(() => mockStorage.setStringList(prefKey, ['a', 'c'])).called(1);

      clearInteractions(mockStorage);

      await notifier.syncAvailableStories(['a', 'c']);
      verifyNever(() => mockStorage.setStringList(any(), any()));
    });
  });
}
