// SPDX-License-Identifier: ice License 1.0

import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/feed/stories/data/models/story.c.dart';
import 'package:ion/app/features/feed/stories/providers/stories_provider.c.dart';
import 'package:ion/app/features/feed/stories/providers/story_viewing_provider.c.dart';

import '../helpers/story_test_models.dart';
import '../helpers/story_test_utils.dart';

void main() {
  setUpAll(registerStoriesFallbacks);

  const alice = 'alice';
  const bob = 'bob';

  final aliceStories = UserStories(
    pubkey: alice,
    stories: [buildPost('a1'), buildPost('a2')],
  );

  final bobStories = UserStories(
    pubkey: bob,
    stories: [buildPost('b1')],
  );

  ProviderContainer buildContainer() => createStoriesContainer(
        overrides: [
          storiesProvider.overrideWith(
            (ref) => [aliceStories, bobStories],
          ),
        ],
      );

  group('StoryViewingController navigation', () {
    test('initial state starts at user 0, story 0', () {
      final container = buildContainer();
      final state = container.read(storyViewingControllerProvider(alice));

      expect(state.currentUserIndex, 0);
      expect(state.currentStoryIndex, 0);
    });

    test('moveToNextStory increments story index within the same user', () {
      final container = buildContainer();
      container.read(storyViewingControllerProvider(alice).notifier).moveToNextStory();

      final state = container.read(storyViewingControllerProvider(alice));

      expect(state.currentUserIndex, 0);
      expect(state.currentStoryIndex, 1); // a2
    });

    test('moveToNextStory on last story jumps to next user', () {
      final container = buildContainer();
      container.read(storyViewingControllerProvider(alice).notifier)
        ..moveToNextStory() // a2
        ..moveToNextStory(); // bob/b1

      final state = container.read(storyViewingControllerProvider(alice));

      expect(state.currentUserIndex, 1); // Bob
      expect(state.currentStoryIndex, 0); // first story of Bob
    });

    test('moveToPreviousStory at first story jumps to previous user', () {
      final container = buildContainer();
      container.read(storyViewingControllerProvider(alice).notifier)
        ..moveToNextStory() // a2
        ..moveToNextStory() // bob/b1
        ..moveToPreviousStory(); // back to Alice/a2

      final state = container.read(storyViewingControllerProvider(alice));

      expect(state.currentUserIndex, 0);
      expect(state.currentStoryIndex, 1); // a2
    });

    test('moveToNextUser / moveToPreviousUser work at boundaries', () {
      final container = buildContainer();
      final notifier = container.read(storyViewingControllerProvider(alice).notifier)
        ..moveToNextUser(); // Bob

      var state = container.read(storyViewingControllerProvider(alice));
      expect(state.currentUserIndex, 1);
      expect(state.currentStoryIndex, 0);

      // Back to Alice
      notifier.moveToPreviousUser();
      state = container.read(storyViewingControllerProvider(alice));
      expect(state.currentUserIndex, 0);
      expect(state.currentStoryIndex, 1);
    });

    test('moveToUser sets indices and chooses first/last story correctly', () {
      final container = buildContainer();
      final notifier = container.read(storyViewingControllerProvider(alice).notifier)
        ..moveToUser(1); // Bob

      var state = container.read(storyViewingControllerProvider(alice));
      expect(state.currentUserIndex, 1);
      expect(state.currentStoryIndex, 0);

      // Back to Alice
      notifier.moveToUser(0);
      state = container.read(storyViewingControllerProvider(alice));
      expect(state.currentUserIndex, 0);
      expect(state.currentStoryIndex, 1);
    });
  });
}
