// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ion_screenshot_detector/ion_screenshot_detector.dart';

IonScreenshotDetector useScreenshotDetector({
  List<Object?>? keys,
}) {
  return use(
    _ScreenshotDetectorHook(
      keys: keys,
    ),
  );
}

class _ScreenshotDetectorHook extends Hook<IonScreenshotDetector> {
  const _ScreenshotDetectorHook({
    super.keys,
  });

  @override
  HookState<IonScreenshotDetector, Hook<IonScreenshotDetector>> createState() =>
      _ScreenshotDetectorHookState();
}

class _ScreenshotDetectorHookState
    extends HookState<IonScreenshotDetector, _ScreenshotDetectorHook> {
  late final detector = IonScreenshotDetector();

  @override
  IonScreenshotDetector build(BuildContext context) => detector;

  @override
  void dispose() => detector.dispose();

  @override
  String get debugLabel => 'useScreenshotDetector';
}
