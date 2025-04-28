// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../test_utils.dart';

Future<void> pumpWithOverrides(
  WidgetTester tester, {
  required Widget child,
  List<Override> overrides = const [],
  List<ProviderObserver>? observers,
}) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: overrides,
      observers: observers,
      child: MaterialApp(home: child),
    ),
  );

  await tester.pump();
}

ProviderContainer createStoriesContainer({
  List<Override> overrides = const [],
  List<ProviderObserver>? observers,
}) =>
    createContainer(overrides: overrides, observers: observers);
