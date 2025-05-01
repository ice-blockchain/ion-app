// SPDX-License-Identifier: ice License 1.0

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ion/app/features/feed/stories/data/models/story.c.dart';

import '../../../../fixtures/factories/post_factory.dart';
import '../../../../robots/stories/story_progress_bar_robot.dart';
import '../helpers/story_test_models.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  ScreenUtil.ensureScreenSize();
  registerStoriesFallbacks();

  const viewerPubkey = 'alice';

  final viewerStories = UserStories(
    pubkey: viewerPubkey,
    stories: [
      makePost('s1', author: viewerPubkey),
      makePost('s2', author: viewerPubkey),
    ],
  );

  group('StoryProgressBarContainer', () {
    testWidgets('renders N segments for N stories', (tester) async {
      final robot = await StoryProgressBarRobot.launch(
        tester,
        stories: [viewerStories],
        viewerPubkey: viewerPubkey,
      );

      robot.expectSegmentCount(2);
    });

    testWidgets('advance() marks previous/current segments correctly', (tester) async {
      final robot = await StoryProgressBarRobot.launch(
        tester,
        stories: [viewerStories],
        viewerPubkey: viewerPubkey,
      );

      robot.advance();
      await tester.pump();

      robot
        ..expectSegmentState(index: 0, isCurrent: false, isPrevious: true)
        ..expectSegmentState(index: 1, isCurrent: true, isPrevious: false);
    });

    testWidgets('advance past last story moves to next user and resets index', (tester) async {
      final bobStories = UserStories(
        pubkey: 'bob',
        stories: [
          makePost('b1', author: 'bob'),
          makePost('b2', author: 'bob'),
        ],
      );

      final robot = await StoryProgressBarRobot.launch(
        tester,
        stories: [viewerStories, bobStories],
        viewerPubkey: viewerPubkey,
      );

      // advance to s2 (same user) and then to bob/b1
      robot
        ..advance()
        ..advance();
      await tester.pump();

      robot
        ..expectViewerState(userIndex: 1, storyIndex: 0)
        ..expectSegmentCount(2)
        ..expectSegmentState(index: 0, isCurrent: true, isPrevious: false)
        ..expectSegmentState(index: 1, isCurrent: false, isPrevious: false);
    });
  });
}
