// SPDX-License-Identifier: ice License 1.0

import 'package:flutter_test/flutter_test.dart';
import 'package:ion/app/features/feed/stories/data/models/story.c.dart';
import 'package:ion/app/features/feed/stories/data/models/story_viewer_state.c.dart';

import '../../../../fixtures/posts/post_fixtures.dart';

void main() {
  group('UserStories', () {
    const pubkey = 'alice_pub';
    final posts = [buildPost('s1'), buildPost('s2'), buildPost('s3')];

    late UserStories userStories;

    setUp(() {
      userStories = UserStories(pubkey: pubkey, stories: posts);
    });

    test('hasStories returns true when list is not empty', () {
      expect(userStories.hasStories, isTrue);
    });

    test('hasStories returns false when list is empty', () {
      const empty = UserStories(pubkey: pubkey, stories: []);
      expect(empty.hasStories, isFalse);
    });

    test('getStoryById returns the correct post or null', () {
      expect(userStories.getStoryById('s2'), same(posts[1]));
      expect(userStories.getStoryById('unknown'), isNull);
    });

    test('getStoryIndex returns index or -1 when not found', () {
      expect(userStories.getStoryIndex('s3'), equals(2));
      expect(userStories.getStoryIndex('missing'), equals(-1));
    });

    test('hasStoryWithId returns true only when id exists', () {
      expect(userStories.hasStoryWithId('s1'), isTrue);
      expect(userStories.hasStoryWithId('absent'), isFalse);
    });
  });

  final userA = UserStories(
    pubkey: 'alice',
    stories: [buildPost('a1'), buildPost('a2')],
  );
  final userB = UserStories(
    pubkey: 'bob',
    stories: [buildPost('b1')],
  );

  group('StoryViewerState navigation getters', () {
    test('hasNextStory / hasPreviousStory behave at boundaries', () {
      var state = StoryViewerState(
        userStories: [userA, userB],
        currentUserIndex: 0,
        currentStoryIndex: 0,
      );
      expect(state.hasNextStory, isTrue);
      expect(state.hasPreviousStory, isFalse);

      state = state.copyWith(currentStoryIndex: 1);
      expect(state.hasNextStory, isFalse);
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

      expect(state.currentStory?.id, equals('b1'));
      expect(state.currentUser?.pubkey, equals('bob'));
    });

    test('currentStory returns null when indices are out of range', () {
      final state = StoryViewerState(
        userStories: [userA],
        currentUserIndex: 0,
        currentStoryIndex: 5,
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
