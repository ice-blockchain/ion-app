// SPDX-License-Identifier: ice License 1.0

import 'package:flutter_test/flutter_test.dart';
import 'package:ion/app/features/feed/stories/data/models/story.c.dart';
import 'package:ion/app/features/feed/stories/providers/stories_provider.c.dart';

import '../../../../fixtures/factories/post_factory.dart';
import '../../../../robots/stories/video_playback_robot.dart';
import '../helpers/story_test_models.dart';
import '../helpers/story_test_utils.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  registerStoriesFallbacks();

  const alice = 'alice';
  const bob = 'bob';

  final aliceVideo = makePost('v1', author: alice);
  final bobImage = makePost('i1', author: bob);

  final aliceStories = UserStories(pubkey: alice, stories: [aliceVideo]);
  final bobStories = UserStories(pubkey: bob, stories: [bobImage]);

  testWidgets(
    'video completion moves to first story of next user (no double advance)',
    (tester) async {
      const duration = Duration(seconds: 3);
      final robot = VideoPlaybackRobot(
        tester,
        post: aliceVideo,
        viewerPubkey: alice,
        duration: duration,
      );

      await pumpWithOverrides(
        tester,
        child: robot.buildHost(),
        overrides: [
          storiesProvider.overrideWith((_) => [aliceStories, bobStories]),
          filteredStoriesByPubkeyProvider(alice).overrideWith((_) => [aliceStories, bobStories]),
          robot.videoOverride,
        ],
      );

      await robot.completeVideo();

      robot.expectViewerState(user: 1, story: 0);
    },
  );
}
