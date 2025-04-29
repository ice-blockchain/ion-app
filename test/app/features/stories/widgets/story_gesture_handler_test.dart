// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/feed/stories/providers/story_pause_provider.c.dart';
import 'package:ion/app/features/feed/stories/views/components/story_viewer/components/core/story_gesture_handler.dart';

class _Flags {
  static bool leftTapped = false;
  static bool rightTapped = false;
  static void reset() => leftTapped = rightTapped = false;
}

class _StoryGestureWrapper extends HookConsumerWidget {
  const _StoryGestureWrapper();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return KeyboardVisibilityProvider(
      child: StoryGestureHandler(
        onTapLeft: () => _Flags.leftTapped = true,
        onTapRight: () => _Flags.rightTapped = true,
        child: const SizedBox.expand(child: ColoredBox(color: Colors.white)),
      ),
    );
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('StoryGestureHandler – golden', () {
    testWidgets('tap left / right triggers correct callbacks', (tester) async {
      _Flags.reset();

      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(home: Scaffold(body: _StoryGestureWrapper())),
        ),
      );

      final handler = find.byType(StoryGestureHandler);
      final size = tester.getSize(handler);

      await tester.tapAt(Offset(size.width * .25, size.height * .5));
      await tester.pump();
      expect(_Flags.leftTapped, isTrue);
      expect(_Flags.rightTapped, isFalse);

      await tester.tapAt(Offset(size.width * .75, size.height * .5));
      await tester.pump();
      expect(_Flags.rightTapped, isTrue);
    });

    testWidgets('long tap sets and removes pause', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(home: Scaffold(body: _StoryGestureWrapper())),
        ),
      );

      final handler = find.byType(StoryGestureHandler);
      final element = tester.element(handler);
      final container = ProviderScope.containerOf(element);

      final pauseSub = container.listen<bool>(
        storyPauseControllerProvider,
        (_, __) {},
        fireImmediately: true,
      );

      final size = tester.getSize(handler);
      final center = Offset(size.width / 2, size.height / 2);

      final gesture = await tester.startGesture(center);
      await tester.pump(const Duration(milliseconds: 600));
      expect(pauseSub.read(), isTrue);

      await gesture.up();
      await tester.pump();
      expect(pauseSub.read(), isFalse);
    });
  });
}
