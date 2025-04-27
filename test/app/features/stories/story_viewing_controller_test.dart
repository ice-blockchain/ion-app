// SPDX-License-Identifier: ice License 1.0

import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/feed/data/models/entities/modifiable_post_data.c.dart';
import 'package:ion/app/features/feed/stories/data/models/story.c.dart';
import 'package:ion/app/features/feed/stories/providers/stories_provider.c.dart';
import 'package:ion/app/features/feed/stories/providers/story_viewing_provider.c.dart';
import 'package:mocktail/mocktail.dart';

import '../../../test_utils.dart';

class _MockPost extends Mock implements ModifiablePostEntity {}

ModifiablePostEntity _post(String id) {
  final p = _MockPost();
  when(() => p.id).thenReturn(id);
  return p;
}

void main() {
  const alice = 'alice';
  const bob = 'bob';

  final aliceStories = UserStories(
    pubkey: alice,
    stories: [_post('a1'), _post('a2')],
  );

  final bobStories = UserStories(
    pubkey: bob,
    stories: [_post('b1')],
  );

  ProviderContainer buildContainer() => createContainer(
        overrides: [
          storiesProvider.overrideWith(
            (ref) => [aliceStories, bobStories],
          ),
        ],
      );

  group('StoryViewingController navigation', () {
    test('initial state starts at user 0, story 0', () {
      final container = buildContainer();
      final state = container.read(
        storyViewingControllerProvider(alice),
      );

      expect(state.currentUserIndex, 0);
      expect(state.currentStoryIndex, 0);
    });

    test('moveToNextStory increments story index within the same user', () {
      final container = buildContainer();
      container.read(storyViewingControllerProvider(alice).notifier).moveToNextStory();
      final state = container.read(
        storyViewingControllerProvider(alice),
      );

      expect(state.currentUserIndex, 0);
      expect(state.currentStoryIndex, 1); // a2
    });

    test('moveToNextStory on last story jumps to next user', () {
      final container = buildContainer();
      container.read(storyViewingControllerProvider(alice).notifier)

        // Go to second (last) story of Alice and then next
        ..moveToNextStory() // -> a2
        ..moveToNextStory(); // -> bob/b1

      final state = container.read(
        storyViewingControllerProvider(alice),
      );

      expect(state.currentUserIndex, 1); // Bob
      expect(state.currentStoryIndex, 0); // first story of Bob
    });

    test('moveToPreviousStory at first story jumps to previous user', () {
      final container = buildContainer();
      container.read(storyViewingControllerProvider(alice).notifier)

        // Move forward to Bob, then back one story (should jump to Alice last)
        ..moveToNextStory() // a2
        ..moveToNextStory() // bob/b1
        ..moveToPreviousStory(); // -> Alice/a2

      final state = container.read(
        storyViewingControllerProvider(alice),
      );

      expect(state.currentUserIndex, 0);
      expect(state.currentStoryIndex, 1); // last story of Alice
    });

    test('moveToNextUser / moveToPreviousUser work at boundaries', () {
      final container = buildContainer();
      final notifier = container.read(storyViewingControllerProvider(alice).notifier)
        ..moveToNextUser();
      var state = container.read(
        storyViewingControllerProvider(alice),
      );
      expect(state.currentUserIndex, 1);
      expect(state.currentStoryIndex, 0);

      // Previous user
      notifier.moveToPreviousUser();
      state = container.read(
        storyViewingControllerProvider(alice),
      );
      expect(state.currentUserIndex, 0);
      expect(state.currentStoryIndex, 1);
    });

    test('moveToUser sets indices and chooses first/last story correctly', () {
      final container = buildContainer();
      final notifier = container.read(storyViewingControllerProvider(alice).notifier)

        // Jump forward: expect first story of Bob
        ..moveToUser(1);
      var state = container.read(
        storyViewingControllerProvider(alice),
      );
      expect(state.currentUserIndex, 1);
      expect(state.currentStoryIndex, 0);

      // Jump backward: expect last story of Alice
      notifier.moveToUser(0);
      state = container.read(
        storyViewingControllerProvider(alice),
      );
      expect(state.currentUserIndex, 0);
      expect(state.currentStoryIndex, 1);
    });
  });
}
