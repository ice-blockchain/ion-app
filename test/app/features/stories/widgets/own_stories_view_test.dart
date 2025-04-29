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

  const me = 'alice';
  const other = 'bob';

  final myStories = UserStories(
    pubkey: me,
    stories: [buildPost('a1'), buildPost('a2')],
  );

  final otherStories = UserStories(
    pubkey: other,
    stories: [buildPost('b1')],
  );

  ProviderContainer createContainer() => createStoriesContainer(
        overrides: [
          storiesProvider.overrideWith((_) => [myStories, otherStories]),
          filteredStoriesByPubkeyProvider(me).overrideWith((_) => [myStories]),
        ],
      );

  group('Own stories viewing', () {
    test(
      'controller receives only current user stories → switching to other authors is impossible',
      () {
        final container = createContainer();
        final initial = container.read(storyViewingControllerProvider(me));

        expect(
          initial.userStories.length,
          1,
          reason: 'List should contain only the current author',
        );
        expect(initial.hasNextUser, isFalse);

        container.read(storyViewingControllerProvider(me).notifier).moveToUser(1);

        final after = container.read(storyViewingControllerProvider(me));
        expect(after.currentUserIndex, 0);
        expect(after.hasNextUser, isFalse);
      },
    );
  });
}
