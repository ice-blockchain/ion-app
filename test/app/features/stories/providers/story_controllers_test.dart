// SPDX-License-Identifier: ice License 1.0

import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/feed/stories/providers/stories_provider.c.dart';
import 'package:ion/app/features/feed/stories/providers/story_viewing_provider.c.dart';
import 'package:ion/app/features/feed/stories/providers/viewed_stories_provider.c.dart';
import 'package:ion/app/services/storage/local_storage.c.dart';
import 'package:ion/app/services/storage/user_preferences_service.c.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks.dart';
import '../helpers/story_test_models.dart';
import '../helpers/story_test_utils.dart';

void main() {
  setUpAll(registerStoriesFallbacks);

  const alice = 'alice';
  const bob = 'bob';

  final aliceUserStories = buildUserStories(alice, ['a1', 'a2']);
  final bobUserStories = buildUserStories(bob, ['b1']);

  ProviderContainer createContainer() => createStoriesContainer(
        overrides: [
          storiesProvider.overrideWith(
            (_) => [aliceUserStories, bobUserStories],
          ),
        ],
      );

  group('StoryViewingController navigation', () {
    test('initial state starts at user 0, story 0', () {
      final container = createContainer();
      final state = container.read(storyViewingControllerProvider(alice));

      expect(state.currentUserIndex, 0);
      expect(state.currentStoryIndex, 0);
    });

    test('advance increments story index within the same user', () {
      final container = createContainer();

      container.read(storyViewingControllerProvider(alice).notifier).advance(); // a2

      final state = container.read(storyViewingControllerProvider(alice));

      expect(state.currentUserIndex, 0);
      expect(state.currentStoryIndex, 1);
    });

    test('advance on last story jumps to next user (story 0)', () {
      final container = createContainer();

      container.read(storyViewingControllerProvider(alice).notifier)
        ..advance() // a2
        ..advance(); // bob/b1

      final state = container.read(storyViewingControllerProvider(alice));

      expect(state.currentUserIndex, 1);
      expect(state.currentStoryIndex, 0);
    });

    test('rewind at first story jumps to previous user (story 0)', () {
      final container = createContainer();

      container.read(storyViewingControllerProvider(alice).notifier)
        ..advance() // a2
        ..advance() // bob/b1
        ..rewind(); // back to Alice/a1

      final state = container.read(storyViewingControllerProvider(alice));

      expect(state.currentUserIndex, 0);
      expect(state.currentStoryIndex, 0);
    });

    test('moveToUser always resets story index to 0', () {
      final container = createContainer();
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
        final container = createContainer();
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

      return createStoriesContainer(
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
