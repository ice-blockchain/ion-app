// SPDX-License-Identifier: ice License 1.0

import 'package:flutter_test/flutter_test.dart';
import 'package:ion/app/features/feed/stories/data/models/story_viewer_state.f.dart';
import 'package:ion/app/features/feed/stories/data/models/user_story.f.dart';

import '../../../../fixtures/posts/post_fixtures.dart';

void main() {
  final userA = UserStory(
    pubkey: 'alice',
    story: buildPost('a1'),
  );
  final userB = UserStory(
    pubkey: 'bob',
    story: buildPost('b1'),
  );

  group('StoryViewerState navigation getters', () {
    test('hasPreviousStory behave at boundaries', () {
      var state = StoryViewerState(
        userStories: [userA, userB],
        currentUserIndex: 0,
        currentStoryIndex: 0,
      );
      expect(state.hasPreviousStory, isFalse);

      state = state.copyWith(currentStoryIndex: 1);
      expect(state.hasPreviousStory, isTrue);
    });

    test('hasNextUser / hasPreviousUser behave at boundaries', () {
      var state = StoryViewerState(
        userStories: [userA, userB],
        currentUserIndex: 0,
        currentStoryIndex: 0,
      );
      expect(state.hasNextUser, isTrue);
      expect(state.hasPreviousUser, isFalse);

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

      expect(state.currentStory?.story.id, equals('b1'));
      expect(state.currentUserPubkey, equals('bob'));
    });

    test('currentStory returns null when indices are out of range', () {
      final state = StoryViewerState(
        userStories: [userA],
        currentUserIndex: 5,
        currentStoryIndex: 0,
      );

      expect(state.currentStory, isNull);
    });
  });
}
