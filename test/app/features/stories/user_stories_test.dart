// SPDX-License-Identifier: ice License 1.0

import 'package:flutter_test/flutter_test.dart';
import 'package:ion/app/features/feed/data/models/entities/modifiable_post_data.c.dart';
import 'package:ion/app/features/feed/stories/data/models/story.c.dart';
import 'package:mocktail/mocktail.dart';

class _MockPost extends Mock implements ModifiablePostEntity {}

ModifiablePostEntity _post(String id) {
  final p = _MockPost();
  when(() => p.id).thenReturn(id);
  return p;
}

void main() {
  const pubkey = 'alice_pub';
  final posts = [_post('s1'), _post('s2'), _post('s3')];

  group('UserStories helpers', () {
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
}
