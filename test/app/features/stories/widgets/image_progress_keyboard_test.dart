// SPDX-License-Identifier: ice License 1.0

import 'package:flutter_test/flutter_test.dart';

import '../../../../robots/stories/image_progress_robot.dart';
import '../helpers/story_test_models.dart';
import '../helpers/story_test_utils.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  registerStoriesFallbacks();

  group('Image progress & keyboard (Robot)', () {
    testWidgets(
      'progress pauses on keyboard open and resumes after close',
      (tester) async {
        final post = buildPost('img_keyboard');
        final robot = ImageProgressRobot(tester, post: post);

        await pumpWithOverrides(
          tester,
          child: robot.buildHost(),
          overrides: storyViewerOverrides(post),
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
