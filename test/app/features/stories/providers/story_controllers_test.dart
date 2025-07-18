// SPDX-License-Identifier: ice License 1.0

import 'package:flutter_test/flutter_test.dart';
import 'package:ion/app/features/feed/data/repository/following_feed_seen_events_repository.r.dart';
import 'package:ion/app/features/feed/stories/providers/feed_stories_provider.r.dart';
import 'package:ion/app/features/feed/stories/providers/story_viewing_provider.r.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../fixtures/stories/story_fixtures.dart';
import '../../../../test_utils.dart';

final class MockFollowingFeedSeenEventsRepository extends Mock
    implements FollowingFeedSeenEventsRepository {}

void main() {
  const alice = StoryFixtures.alice;
  const bob = StoryFixtures.bob;

  final aliceUserStories = StoryFixtures.userStory();
  final aliceStories = StoryFixtures.stories(count: 2);
  final bobUserStories = StoryFixtures.userStory(pubkey: bob);

  final overrides = [
    feedStoriesByPubkeyProvider(alice).overrideWithValue([aliceUserStories, bobUserStories]),
  ];

  group('UserStoriesViewingNotifier (multi-user)', () {
    test('initial state starts at user index 0', () {
      final container = createContainer(overrides: overrides);
      final state = container.read(
        userStoriesViewingNotifierProvider(alice),
      );
      expect(state.currentUserIndex, equals(0));
    });

    test('advance() moves to next user while in bounds', () {
      final container = createContainer(overrides: overrides);
      final notifier = container.read(
        userStoriesViewingNotifierProvider(alice).notifier,
      );
      final didAdvance = notifier.advance();
      final state = container.read(
        userStoriesViewingNotifierProvider(alice),
      );

      expect(didAdvance, isTrue);
      expect(state.currentUserIndex, equals(1));
    });

    test('advance() at last user calls onClose and does not change index', () {
      final container = createContainer(overrides: overrides);
      final notifier = container.read(
        userStoriesViewingNotifierProvider(alice).notifier,
      )..advance(); // now at index 1 (Bob)
      var wasClosed = false;
      final didAdvance = notifier.advance(onClose: () => wasClosed = true);
      final state = container.read(
        userStoriesViewingNotifierProvider(alice),
      );

      expect(didAdvance, isFalse);
      expect(wasClosed, isTrue);
      expect(state.currentUserIndex, equals(1));
    });

    test('rewind() moves back one user while in bounds', () {
      final container = createContainer(overrides: overrides);
      final notifier = container.read(
        userStoriesViewingNotifierProvider(alice).notifier,
      )..advance(); // move to Bob
      final didRewind = notifier.rewind();
      final state = container.read(
        userStoriesViewingNotifierProvider(alice),
      );

      expect(didRewind, isTrue);
      expect(state.currentUserIndex, equals(0));
    });

    test('rewind() at first user calls onClose and does not change index', () {
      final container = createContainer(overrides: overrides);
      final notifier = container.read(
        userStoriesViewingNotifierProvider(alice).notifier,
      );
      var wasClosed = false;
      final didRewind = notifier.rewind(onClose: () => wasClosed = true);
      final state = container.read(
        userStoriesViewingNotifierProvider(alice),
      );

      expect(didRewind, isFalse);
      expect(wasClosed, isTrue);
      expect(state.currentUserIndex, equals(0));
    });

    test('moveTo(index) sets the currentUserIndex (ignores –1)', () {
      final container = createContainer(overrides: overrides);
      final notifier = container.read(
        userStoriesViewingNotifierProvider(alice).notifier,
      )..moveTo(1);
      var state = container.read(
        userStoriesViewingNotifierProvider(alice),
      );
      expect(state.currentUserIndex, equals(1));

      notifier.moveTo(-1);
      state = container.read(
        userStoriesViewingNotifierProvider(alice),
      );
      expect(state.currentUserIndex, equals(1));
    });
  });

  group('SingleUserStoryViewingController (single-user)', () {
    test('initial state starts at story index 0', () {
      final container = createContainer();
      final state = container.read(
        singleUserStoryViewingControllerProvider(alice),
      );
      expect(state.currentStoryIndex, equals(0));
    });

    test('advance() increments storyIndex while in bounds', () {
      final container = createContainer();
      final notifier = container.read(
        singleUserStoryViewingControllerProvider(alice).notifier,
      );
      final didAdvance = notifier.advance(storiesLength: aliceStories.length);
      final state = container.read(
        singleUserStoryViewingControllerProvider(alice),
      );

      expect(didAdvance, isTrue);
      expect(state.currentStoryIndex, equals(1));
    });

    test('advance() at last story calls onSeenAll and does not change index', () {
      final container = createContainer();
      final notifier = container.read(
        singleUserStoryViewingControllerProvider(alice).notifier,
      )..advance(storiesLength: aliceStories.length); // now at 1
      var wasSeenAll = false;
      final didAdvance = notifier.advance(
        storiesLength: aliceStories.length,
        onSeenAll: () => wasSeenAll = true,
      );
      final state = container.read(
        singleUserStoryViewingControllerProvider(alice),
      );

      expect(didAdvance, isFalse);
      expect(wasSeenAll, isTrue);
      expect(state.currentStoryIndex, equals(1));
    });

    test('rewind() decrements storyIndex while in bounds', () {
      final container = createContainer();
      final notifier = container.read(
        singleUserStoryViewingControllerProvider(alice).notifier,
      )..advance(storiesLength: aliceStories.length);
      final didRewind = notifier.rewind();
      final state = container.read(
        singleUserStoryViewingControllerProvider(alice),
      );

      expect(didRewind, isTrue);
      expect(state.currentStoryIndex, equals(0));
    });

    test('rewind() at first story calls onRewoundAll and does not change index', () {
      final container = createContainer();
      final notifier = container.read(
        singleUserStoryViewingControllerProvider(alice).notifier,
      );
      var wasRewoundAll = false;
      final didRewind = notifier.rewind(onRewoundAll: () => wasRewoundAll = true);
      final state = container.read(
        singleUserStoryViewingControllerProvider(alice),
      );

      expect(didRewind, isFalse);
      expect(wasRewoundAll, isTrue);
      expect(state.currentStoryIndex, equals(0));
    });

    test('moveToStoryIndex(index) sets the storyIndex (ignores –1)', () {
      final container = createContainer();
      final notifier = container.read(
        singleUserStoryViewingControllerProvider(alice).notifier,
      )..moveToStoryIndex(1);
      var state = container.read(
        singleUserStoryViewingControllerProvider(alice),
      );
      expect(state.currentStoryIndex, equals(1));

      notifier.moveToStoryIndex(-1);
      state = container.read(
        singleUserStoryViewingControllerProvider(alice),
      );
      expect(state.currentStoryIndex, equals(1));
    });
  });
}
