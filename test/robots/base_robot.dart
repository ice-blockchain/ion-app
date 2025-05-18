// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ion/app/services/logger/logger.dart';

abstract class BaseRobot {
  const BaseRobot(this.tester);

  @protected
  final WidgetTester tester;

  Finder $(Key key) => find.byKey(key);

  Future<void> tap(Key key) async {
    await tester.tap($(key));
    await tester.pumpAndSettle();
  }

  Future<void> longPress(Key key, {Duration duration = const Duration(milliseconds: 600)}) async {
    await tester.longPress($(key), warnIfMissed: false);
    await tester.pump(duration);
    await tester.pumpAndSettle();
  }

  Future<void> enterText(Key key, String text) async {
    await tester.enterText($(key), text);
    await tester.pumpAndSettle();
  }

  Future<void> drag(Key key, Offset offset, {int speed = 1000}) async {
    await tester.fling($(key), offset, speed.toDouble());
    await tester.pumpAndSettle();
  }

  @protected
  void expectVisible(Key key) => expect($(key), findsOneWidget);

  @protected
  void expectAbsent(Key key) => expect($(key), findsNothing);

  Future<bool> waitFor(
    bool Function() condition, {
    Duration timeout = const Duration(seconds: 5),
    Duration pollEvery = const Duration(milliseconds: 50),
  }) async {
    final end = DateTime.now().add(timeout);

    while (DateTime.now().isBefore(end)) {
      if (condition()) return true;
      await tester.pump(pollEvery);
    }
    return false;
  }

  Future<void> waitUntilVisible(
    Finder finder, {
    Duration timeout = const Duration(seconds: 5),
  }) async {
    final ok = await waitFor(() => tester.any(finder), timeout: timeout);
    if (!ok) {
      throw TestFailure('Widget $finder did not appear within $timeout');
    }
  }

  Future<void> wait(Duration duration) async => tester.pump(duration);

  /// Dumps the widget tree to the console
  void debugDumpTree({String header = 'WIDGET TREE'}) {
    if (!kDebugMode) return;
    Logger.log('\n=== $header ===\n${tester.binding.rootElement?.toStringDeep()}\n===============');
  }
  
  /// Waits until a widget with the given [key] is present
  Future<void> waitUntilPresent(Key key, {Duration timeout = const Duration(seconds: 5)}) async {
    await waitUntilVisible($(key), timeout: timeout);
  }
  
  /// Expects to find exactly one widget with the given [text]
  void expectText(String text) => expect(find.text(text), findsOneWidget);
  
  /// Expects no widget with the given [text] to be found
  void expectNoText(String text) => expect(find.text(text), findsNothing);
  
  /// Expects to find exactly n widgets with the given [text]
  void expectTextCount(String text, int count) => expect(find.text(text), findsNWidgets(count));
}
