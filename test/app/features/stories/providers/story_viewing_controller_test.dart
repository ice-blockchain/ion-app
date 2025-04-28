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

  final aliceUserStories = UserStories(
    pubkey: alice,
    stories: [buildPost('a1'), buildPost('a2')],
  );

  final bobUserStories = UserStories(
    pubkey: bob,
    stories: [buildPost('b1')],
  );

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

      expect(state.currentUserIndex, 1); // Bob
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
  });
}
