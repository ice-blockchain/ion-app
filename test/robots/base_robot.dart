// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ion/app/services/logger/logger.dart';

abstract class BaseRobot {
  const BaseRobot(this.tester);

  @protected
  final WidgetTester tester;

  Finder byKey(Key key) => find.byKey(key);

  Future<void> tap(Key key) async {
    await tester.tap(byKey(key));
    await tester.pumpAndSettle();
  }

  Future<void> longPress(Key key, {Duration duration = const Duration(milliseconds: 600)}) async {
    await tester.longPress(byKey(key), warnIfMissed: false);
    await tester.pump(duration);
    await tester.pumpAndSettle();
  }

  Future<void> enterText(Key key, String text) async {
    await tester.enterText(byKey(key), text);
    await tester.pumpAndSettle();
  }

  Future<void> drag(Key key, Offset offset, {int speed = 1000}) async {
    await tester.fling(byKey(key), offset, speed.toDouble());
    await tester.pumpAndSettle();
  }

  @protected
  void expectVisible(Key key) => expect(byKey(key), findsOneWidget);

  @protected
  void expectAbsent(Key key) => expect(byKey(key), findsNothing);

  Future<bool> waitForCondition(
    bool Function() condition, {
    Duration timeout = const Duration(seconds: 5),
  }) async {
    final end = DateTime.now().add(timeout);

    while (!condition()) {
      if (DateTime.now().isAfter(end)) {
        return false;
      }
      await tester.pumpAndSettle();
      await Future<void>.delayed(const Duration(milliseconds: 100));
    }

    return true;
  }

  Future<void> waitUntilVisible(
    Finder finder, {
    Duration timeout = const Duration(seconds: 5),
  }) async {
    final ok = await waitForCondition(() => tester.any(finder), timeout: timeout);
    if (!ok) {
      throw TestFailure('Widget $finder did not appear within $timeout');
    }
  }

  /// Taps at relative position within widget (dx/dy: 0-1 fractional coordinates)
  Future<void> tapRelative(
    Finder finder, {
    required double dx,
    required double dy,
  }) async {
    final widgetElement = tester.element(finder);
    final renderBox = widgetElement.renderObject! as RenderBox;
    final position = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;

    await tester.tapAt(position + Offset(size.width * dx, size.height * dy));
    await tester.pump();
  }

  Future<void> wait(Duration duration) async => tester.pump(duration);

  /// Dumps the widget tree to the console
  void debugDumpTree({String header = 'WIDGET TREE'}) {
    if (!kDebugMode) return;
    Logger.log('\n=== $header ===\n${tester.binding.rootElement?.toStringDeep()}\n===============');
  }

  /// Waits until a widget with the given [key] is present
  Future<void> waitUntilPresent(Key key, {Duration timeout = const Duration(seconds: 5)}) async {
    await waitUntilVisible(byKey(key), timeout: timeout);
  }

  /// Expects to find exactly one widget with the given [text]
  void expectText(String text) => expect(find.text(text), findsOneWidget);

  /// Expects no widget with the given [text] to be found
  void expectNoText(String text) => expect(find.text(text), findsNothing);

  /// Expects to find exactly n widgets with the given [text]
  void expectTextCount(String text, int count) => expect(find.text(text), findsNWidgets(count));
}
