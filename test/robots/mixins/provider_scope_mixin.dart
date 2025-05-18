// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../base_robot.dart';

/// Mixin providing helper methods for working with ProviderScope in tests
mixin ProviderScopeMixin on BaseRobot {
  ProviderContainer getContainerFromFinder(Finder finder) =>
      ProviderScope.containerOf(tester.element(finder));

  ProviderContainer getContainerFromKey(Key key) =>
      ProviderScope.containerOf(tester.element($(key)));
}
