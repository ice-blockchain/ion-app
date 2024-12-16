// SPDX-License-Identifier: ice License 1.0

import 'dart:async';
import 'dart:ui';

import 'package:flutter_hooks/flutter_hooks.dart';

/// Executes a callback function at a specified interval.
///
/// The [delay] parameter specifies the duration between each callback execution.
/// The [callback] parameter is the function to be executed.
/// If [oneTime] is true, the callback executes once after delay, otherwise repeatedly at the interval.
void useInterval({
  required Duration delay,
  required VoidCallback callback,
  bool oneTime = false,
}) {
  assert(delay > Duration.zero, 'Delay must be positive');

  useEffect(
    () {
      final timer = oneTime
          ? Timer(delay, callback)
          : Timer.periodic(
              delay,
              (_) => callback,
            );

      return timer.cancel;
    },
    [delay],
  );
}
