// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:sensors_plus/sensors_plus.dart';

/// A widget that detects when device is flipped upside down and held for 1 second.
class DeviceRotationDetector extends HookWidget {
  const DeviceRotationDetector({
    required this.child,
    required this.onRotate,
    this.holdDuration = const Duration(seconds: 1),
    super.key,
  });

  final VoidCallback onRotate;
  final Widget child;
  final Duration holdDuration;

  @override
  Widget build(BuildContext context) {
    final holdTimer = useState<Timer?>(null);
    final isUpsideDown = useState<bool>(false);

    useEffect(
      () {
        final subscription = accelerometerEventStream().listen((AccelerometerEvent event) {
          final currentlyUpsideDown = event.y < -9.0;

          if (currentlyUpsideDown != isUpsideDown.value) {
            isUpsideDown.value = currentlyUpsideDown;

            holdTimer.value?.cancel();

            if (currentlyUpsideDown) {
              holdTimer.value = Timer(holdDuration, () {
                onRotate();
                holdTimer.value = null;
              });
            } else {
              holdTimer.value = null;
            }
          }
        });

        return () {
          subscription.cancel();
          holdTimer.value?.cancel();
        };
      },
      const [],
    );

    return child;
  }
}
