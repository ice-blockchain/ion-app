// SPDX-License-Identifier: ice License 1.0

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/posts/post_fixtures.dart';
import '../../../../fixtures/stories/story_fixtures.dart';
import '../../../../helpers/robot_test_harness.dart';
import '../../../../robots/stories/image_progress_robot.dart';
import '../../../../robots/stories/story_progress_bar_robot.dart';
import '../../../../robots/stories/story_viewer_robot.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  ScreenUtil.ensureScreenSize();

  const viewerPubkey = StoryFixtures.alice;
  final viewerUserStory = StoryFixtures.userStory();
  final viewerStories = StoryFixtures.stories(
    count: 1,
  );

  group('StoryProgressBarContainer', () {
    testWidgets('renders N segments for N stories', (tester) async {
      final robot = await StoryProgressBarRobot.launch(
        tester,
        stories: [viewerUserStory],
        viewerPubkey: viewerPubkey,
      );
      robot.expectSegmentCount(2);
    });

    testWidgets('advance() marks previous/current segments correctly', (tester) async {
      final robot = await StoryProgressBarRobot.launch(
        tester,
        stories: [viewerUserStory],
        viewerPubkey: viewerPubkey,
      );
      robot.advance(stories: viewerStories);
      await tester.pump();
      robot
        ..expectSegmentState(index: 0, isCurrent: false, isPrevious: true)
        ..expectSegmentState(index: 1, isCurrent: true, isPrevious: false);
    });

    testWidgets('advance past last story moves to next user and resets index', (tester) async {
      final bobStories = StoryFixtures.userStory(
        pubkey: StoryFixtures.bob,
      );

      final robot = await StoryProgressBarRobot.launch(
        tester,
        stories: [viewerUserStory, bobStories],
        viewerPubkey: viewerPubkey,
      );
      robot
        ..advance(stories: viewerStories)
        ..advance(stories: viewerStories);
      await tester.pump();
      robot
        ..expectViewerState(userIndex: 1, storyIndex: 0)
        ..expectSegmentCount(2)
        ..expectSegmentState(index: 0, isCurrent: true, isPrevious: false)
        ..expectSegmentState(index: 1, isCurrent: false, isPrevious: false);
    });
  });

  group('Image progress & keyboard (Robot)', () {
    testWidgets(
      'progress pauses on keyboard open and resumes after close',
      (tester) async {
        final post = buildPost('img_keyboard');
        final robot = ImageProgressRobot(tester, post: post);

        await tester.pumpWithHarness(
          childBuilder: (ref) => robot.buildImageProgressWidget(),
          overrides: StoryViewerRobot.storyViewerOverrides(
            post: post,
            pubkey: StoryFixtures.alice,
          ),
        );
        await robot.attach();

        robot.markImageLoaded(); // preload done
        await robot.wait(const Duration(seconds: 2));

        // Act 1 – open keyboard (= pause)
        robot.paused = true;
        await robot.wait(Duration.zero);
        final frozen = robot.progress;

        await robot.wait(const Duration(seconds: 1));

        robot
          ..expectFrozen(frozen)
          ..paused = false;
        await tester.pumpAndSettle(const Duration(seconds: 4));

        robot.expectCompleted();
      },
    );
  });
}
