// SPDX-License-Identifier: ice License 1.0


import 'package:flutter_test/flutter_test.dart';
import 'package:ion/app/features/feed/data/models/entities/modifiable_post_data.c.dart';
import 'package:ion/app/features/feed/stories/data/models/story.c.dart';
import 'package:ion/app/features/feed/stories/data/models/story_viewer_state.c.dart';
import 'package:mocktail/mocktail.dart';

class _MockPost extends Mock implements ModifiablePostEntity {}

ModifiablePostEntity _post(String id) {
  final p = _MockPost();
  when(() => p.id).thenReturn(id);
  return p;
}

void main() {
  final userA = UserStories(pubkey: 'alice', stories: [_post('a1'), _post('a2')]);
  final userB = UserStories(pubkey: 'bob', stories: [_post('b1')]);

  group('StoryViewerState navigation getters', () {
    test('hasNextStory / hasPreviousStory behave at boundaries', () {
      // middle of userA
      var state = StoryViewerState(
        userStories: [userA, userB],
        currentUserIndex: 0,
        currentStoryIndex: 0,
      );
      expect(state.hasNextStory, isTrue);
      expect(state.hasPreviousStory, isFalse);

      // last story of userA
      state = state.copyWith(currentStoryIndex: 1);
      expect(state.hasNextStory, isFalse);
      expect(state.hasPreviousStory, isTrue);
    });

    test('hasNextUser / hasPreviousUser behave at boundaries', () {
      // first user
      var state = StoryViewerState(
        userStories: [userA, userB],
        currentUserIndex: 0,
        currentStoryIndex: 0,
      );
      expect(state.hasNextUser, isTrue);
      expect(state.hasPreviousUser, isFalse);

      // last user
      state = state.copyWith(currentUserIndex: 1);
      expect(state.hasNextUser, isFalse);
      expect(state.hasPreviousUser, isTrue);
    });
  });

  group('currentStory & currentUser getters', () {
    test('currentStory returns correct entity', () {
      final state = StoryViewerState(
        userStories: [userA, userB],
        currentUserIndex: 1,
        currentStoryIndex: 0,
      );

      expect(state.currentStory?.id, equals('b1'));
      expect(state.currentUser?.pubkey, equals('bob'));
    });

    test('currentStory returns null when indices are out of range', () {
      final state = StoryViewerState(
        userStories: [userA],
        currentUserIndex: 0,
        currentStoryIndex: 5, // beyond list length
      );

      expect(state.currentStory, isNull);
    });

    test('currentStory returns null when there are no stories', () {
      const emptyUser = UserStories(pubkey: 'carol', stories: []);
      const state = StoryViewerState(
        userStories: [emptyUser],
        currentUserIndex: 0,
        currentStoryIndex: 0,
      );

      expect(state.currentStory, isNull);
    });
  });
}
