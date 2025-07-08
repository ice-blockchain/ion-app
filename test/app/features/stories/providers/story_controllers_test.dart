// SPDX-License-Identifier: ice License 1.0

import 'package:flutter_test/flutter_test.dart';
import 'package:ion/app/features/feed/data/repository/following_feed_seen_events_repository.r.dart';
import 'package:ion/app/features/feed/stories/providers/feed_stories_provider.r.dart';
import 'package:ion/app/features/feed/stories/providers/story_viewing_provider.r.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../fixtures/stories/story_fixtures.dart';
import '../../../../test_utils.dart';
import '../data/fake_feed_stories_state.dart';

final class MockFollowingFeedSeenEventsRepository extends Mock
    implements FollowingFeedSeenEventsRepository {}

void main() {
  const alice = StoryFixtures.alice;
  const bob = StoryFixtures.bob;

  final aliceUserStories = StoryFixtures.userStory();
  final aliceStories = StoryFixtures.stories(
    count: 2,
  );
  final bobUserStories = StoryFixtures.userStory(
    pubkey: bob,
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

      container
          .read(storyViewingControllerProvider(alice).notifier)
          .advance(stories: aliceStories); // a2

      final state = container.read(storyViewingControllerProvider(alice));

      expect(state.currentUserIndex, 0);
      expect(state.currentStoryIndex, 1);
    });

    test('advance on last story jumps to next user (story 0)', () {
      final container = createContainer(overrides: overrides);

      container.read(storyViewingControllerProvider(alice).notifier)
        ..advance(stories: aliceStories) // a2
        ..advance(stories: aliceStories); // bob/b1

      final state = container.read(storyViewingControllerProvider(alice));

      expect(state.currentUserIndex, 1);
      expect(state.currentStoryIndex, 0);
    });

    test('rewind at first story jumps to previous user (story 0)', () {
      final container = createContainer(overrides: overrides);

      container.read(storyViewingControllerProvider(alice).notifier)
        ..advance(stories: aliceStories) // a2
        ..advance(stories: aliceStories) // bob/b1
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
        final notifier = container.read(storyViewingControllerProvider(alice).notifier)
          ..advance(stories: aliceStories);

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
}
