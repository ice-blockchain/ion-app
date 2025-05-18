// SPDX-License-Identifier: ice License 1.0

import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/feed/stories/providers/story_pause_provider.c.dart';
import 'package:ion/app/features/feed/stories/views/components/story_viewer/components/core/story_gesture_handler.dart';

import '../../../../robots/stories/story_gesture_robot.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('StoryGestureHandler', () {
    testWidgets('tap left / right triggers correct callbacks', (tester) async {
      final robot = StoryGestureRobot(tester);

      await tester.pumpWidget(robot.buildGestureWidget());
      await robot.attach();

      await robot.tapLeft();
      robot
        ..expectLeftTapped()
        ..expectRightTapped(value: false);

      await robot.tapRight();
      robot.expectRightTapped();
    });

    testWidgets('long press sets and clears pause flag', (tester) async {
      final robot = StoryGestureRobot(tester);

      await tester.pumpWidget(robot.buildGestureWidget());
      await robot.attach();

      final container = ProviderScope.containerOf(
        tester.element(find.byType(StoryGestureHandler)),
      );
      final pauseSub = container.listen<bool>(
        storyPauseControllerProvider,
        (_, __) {},
        fireImmediately: true,
      );

      final gesture = await robot.startPressCenter();
      await tester.pump(const Duration(milliseconds: 600));
      expect(pauseSub.read(), isTrue, reason: 'should be paused while holding');

      await gesture.up();
      await tester.pump();
      expect(pauseSub.read(), isFalse, reason: 'should resume after release');
    });
  });
}
