// SPDX-License-Identifier: ice License 1.0

import 'package:flutter_test/flutter_test.dart';
import 'package:ion/app/features/feed/stories/data/models/story.c.dart';
import 'package:ion/app/features/feed/stories/providers/stories_provider.c.dart';

import '../helpers/story_test_utils.dart';

void main() {
  const alice = 'alice_pub';
  const bob = 'bob_pub';
  const carol = 'carol_pub';

  const dummyStories = [
    UserStories(pubkey: alice, stories: []),
    UserStories(pubkey: bob, stories: []),
    UserStories(pubkey: carol, stories: []),
  ];

  group('filteredStoriesByPubkeyProvider', () {
    test('returns a list starting with the selected user', () {
      final container = createStoriesContainer(
        overrides: [
          storiesProvider.overrideWith((_) => dummyStories),
        ],
      );

      final result = container.read(filteredStoriesByPubkeyProvider(bob));

      expect(result.first.pubkey, equals(bob));
      expect(result.length, equals(2));
    });

    test('returns an empty list if pubkey is not found', () {
      final container = createStoriesContainer(
        overrides: [
          storiesProvider.overrideWith((_) => dummyStories),
        ],
      );

      final result = container.read(
        filteredStoriesByPubkeyProvider('unknown_pubkey'),
      );

      expect(result, isEmpty);
    });
  });
}
