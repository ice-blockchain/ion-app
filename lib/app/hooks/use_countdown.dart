// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

({ValueNotifier<int> countdown, void Function() startCountdown}) useCountdown(int initialCount) {
  final countdown = useState(0);
  Timer? timer;

  void startCountdown() {
    countdown.value = initialCount;
    timer?.cancel();
    timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (countdown.value > 0) {
          countdown.value--;
        } else {
          timer.cancel();
        }
      },
    );
  }

  useEffect(
    () {
      return () {
        timer?.cancel();
      };
    },
    [],
  );

  return (countdown: countdown, startCountdown: startCountdown);
}
