// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/core/model/media_type.dart';
import 'package:ion/app/features/core/providers/video_player_provider.c.dart';
import 'package:ion/app/features/feed/data/models/entities/modifiable_post_data.c.dart';
import 'package:ion/app/features/feed/stories/data/models/story.c.dart';
import 'package:ion/app/features/feed/stories/hooks/use_story_video_playback.dart';
import 'package:ion/app/features/feed/stories/providers/stories_provider.c.dart';
import 'package:ion/app/features/feed/stories/providers/story_viewing_provider.c.dart';

import '../helpers/story_test_models.dart';
import '../helpers/story_test_utils.dart';
import '../helpers/story_test_video.dart';

class _VideoPlaybackHost extends HookConsumerWidget {
  const _VideoPlaybackHost({
    required this.post,
    required this.viewerPubkey,
  });

  final ModifiablePostEntity post;
  final String viewerPubkey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ctrl = ref
        .watch(
          videoControllerProvider(
            const VideoControllerParams(sourcePath: 'dummy', authorPubkey: 'alice'),
          ),
        )
        .value;

    useStoryVideoPlayback(
      ref: ref,
      controller: ctrl,
      storyId: post.id,
      viewerPubkey: viewerPubkey,
      onCompleted: () {
        ref.read(storyViewingControllerProvider(viewerPubkey).notifier).advance();
      },
    );

    return const SizedBox.shrink();
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  registerStoriesFallbacks();

  const alice = 'alice';
  const bob = 'bob';

  final aliceVideoStory = buildPost('v1', mediaType: MediaType.video);
  final bobImageStory = buildPost('i1', author: bob);

  final user1 = UserStories(pubkey: alice, stories: [aliceVideoStory]);
  final user2 = UserStories(pubkey: bob, stories: [bobImageStory]);

  testWidgets(
    'video completion moves to first story of next user (no double advance)',
    (tester) async {
      const duration = Duration(seconds: 3);
      final fakeCtrl = FakeVideoController(duration);

      await pumpWithOverrides(
        tester,
        child: _VideoPlaybackHost(
          post: aliceVideoStory,
          viewerPubkey: alice,
        ),
        overrides: [
          storiesProvider.overrideWith((_) => [user1, user2]),
          filteredStoriesByPubkeyProvider(alice).overrideWith((_) => [user1, user2]),
          videoPlayerControllerFactoryProvider('dummy')
              .overrideWith((_) => FakeVideoFactory(fakeCtrl)),
        ],
      );

      fakeCtrl
        ..value = fakeCtrl.value.copyWith(position: duration)
        ..notifyListeners();

      await tester.pump();

      final state = ProviderScope.containerOf(tester.element(find.byType(_VideoPlaybackHost)))
          .read(storyViewingControllerProvider(alice));

      expect(state.currentUserIndex, 1, reason: 'Should switch to Bob');
      expect(
        state.currentStoryIndex,
        0,
        reason: 'Should be first story of next user, not second',
      );
    },
  );
}
