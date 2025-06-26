// SPDX-License-Identifier: ice License 1.0

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'splash_provider.r.g.dart';

@Riverpod(keepAlive: true)
class Splash extends _$Splash {
  @override
  bool build() {
    return false;
  }

  set animationCompleted(bool completed) {
    state = completed;
  }
}
