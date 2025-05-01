// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/feed/stories/providers/story_viewing_provider.c.dart';
import 'package:ion/app/features/feed/stories/views/components/story_viewer/components/core/story_gesture_handler.dart';

import '../base_robot.dart';

typedef _GestureHandler = StoryGestureHandler;

class StoryViewerRobot extends BaseRobot {
  StoryViewerRobot(
    super.tester, {
    required this.viewerPubkey,
  });

  final String viewerPubkey;

  Finder get _swiper => find.byWidgetPredicate(
        (widget) => widget.runtimeType.toString() == 'StoriesSwiper',
      );

  Finder get _gesture => find.byKey(ValueKey('story_gesture_$viewerPubkey'));

  ProviderContainer get _container => ProviderScope.containerOf(tester.element(_gesture));

  Future<void> swipeToNextUser() async {
    await tester.fling(_swiper, const Offset(-600, 0), 1000);
    await tester.pumpAndSettle();
  }

  Future<void> swipeToPreviousUser() async {
    await tester.fling(_swiper, const Offset(600, 0), 1000);
    await tester.pumpAndSettle();
  }

  Future<void> tapNextStory() async {
    final handler = tester.widget<_GestureHandler>(_gesture);
    handler.onTapRight();
    await tester.pump();
  }

  Future<void> tapPreviousStory() async {
    final handler = tester.widget<_GestureHandler>(_gesture);
    handler.onTapLeft();
    await tester.pump();
  }

  Future<void> longPressCenter({
    Duration duration = const Duration(milliseconds: 600),
  }) async {
    final gesture = await startPressCenter();
    await tester.pump(duration);
    await releasePress(gesture);
  }

  Future<TestGesture> startPressCenter() async {
    final rect = tester.getRect(_gesture);
    final center = rect.center;
    final gesture = await tester.startGesture(center);
    await tester.pump();
    return gesture;
  }

  Future<void> releasePress(TestGesture gesture) async {
    await gesture.up();
    await tester.pumpAndSettle();
  }

  void expectStoryIndex(int index) {
    final state = _container.read(storyViewingControllerProvider(viewerPubkey));
    expect(
      state.currentStoryIndex,
      index,
      reason: 'Expected currentStoryIndex == $index',
    );
  }

  void expectUserIndex(int index) {
    final state = _container.read(storyViewingControllerProvider(viewerPubkey));
    expect(
      state.currentUserIndex,
      index,
      reason: 'Expected currentUserIndex == $index',
    );
  }

  Future<void> _tapFractional(Offset fraction) async {
    final rect = tester.getRect(_gesture);
    final position = Offset(
      rect.left + rect.width * fraction.dx,
      rect.top + rect.height * fraction.dy,
    );
    await tester.tapAt(position);
    await tester.pumpAndSettle();
  }
}
