// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/feed/stories/providers/story_pause_provider.c.dart';
import 'package:ion/app/features/feed/stories/views/components/story_viewer/components/core/story_gesture_handler.dart';

import '../base_robot.dart';
import '../mixins/provider_scope_mixin.dart';

class StoryGestureRobot extends BaseRobot with ProviderScopeMixin {
  StoryGestureRobot(super.tester);

  bool _leftTapped = false;
  bool _rightTapped = false;

  Finder get _handler => find.byType(StoryGestureHandler);

  ProviderContainer get _container => getContainerFromFinder(_handler);

  Widget buildHost() {
    return ProviderScope(
      child: MaterialApp(
        home: Scaffold(
          body: KeyboardVisibilityProvider(
            child: StoryGestureHandler(
              onTapLeft: _onLeftTap,
              onTapRight: _onRightTap,
              child: const SizedBox.expand(
                child: ColoredBox(color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> attach() => waitUntilVisible(_handler);

  void _onLeftTap() => _leftTapped = true;
  void _onRightTap() => _rightTapped = true;

  Future<TestGesture> startPressCenter() async {
    final size = tester.getSize(_handler);
    final center = Offset(size.width / 2, size.height / 2);
    final gesture = await tester.startGesture(center);
    await tester.pump();
    return gesture;
  }

  Future<void> tapLeft() async {
    final size = tester.getSize(_handler);
    await tester.tapAt(Offset(size.width * .25, size.height * .5));
    await tester.pump();
  }

  Future<void> tapRight() async {
    final size = tester.getSize(_handler);
    await tester.tapAt(Offset(size.width * .75, size.height * .5));
    await tester.pump();
  }

  Future<void> longPressCenter({
    Duration duration = const Duration(milliseconds: 600),
  }) async {
    final size = tester.getSize(_handler);
    final center = Offset(size.width / 2, size.height / 2);
    final gesture = await tester.startGesture(center);
    await tester.pump(duration);
    await gesture.up();
    await tester.pump();
  }

  void expectLeftTapped({bool value = true}) => expect(_leftTapped, value, reason: 'left-tap flag');

  void expectRightTapped({bool value = true}) =>
      expect(_rightTapped, value, reason: 'right-tap flag');

  void expectPaused({required bool value}) =>
      expect(_container.read(storyPauseControllerProvider), value);
}
