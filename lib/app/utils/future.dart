// SPDX-License-Identifier: ice License 1.0
export 'package:flutter_animate/flutter_animate.dart';

Future<T> delayed<T>(T Function() action, {Duration after = Duration.zero}) {
  return Future<T>.delayed(after, action);
}
