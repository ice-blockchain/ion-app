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

  ProviderContainer buildContainer() => createStoriesContainer(
        overrides: [
          storiesProvider.overrideWith((_) => [myStories, otherStories]),
          filteredStoriesByPubkeyProvider(me).overrideWith((_) => [myStories]),
        ],
      );

  group('Own stories viewing', () {
    test(
      'controller receives only current user stories → switching to other authors is impossible',
      () {
        final container = buildContainer();
        final state = container.read(storyViewingControllerProvider(me));

        expect(
          state.userStories.length,
          1,
          reason: 'The list should contain only the current author',
        );
        expect(state.hasNextUser, isFalse);

        container.read(storyViewingControllerProvider(me).notifier).moveToNextUser();

        final after = container.read(storyViewingControllerProvider(me));
        expect(after.currentUserIndex, 0);
        expect(after.hasNextUser, isFalse);
      },
    );
  });
}
