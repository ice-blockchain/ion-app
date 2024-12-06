// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/foundation.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ion_screenshot_detector/ion_screenshot_detector.dart';

void useOnScreenshot(VoidCallback callback) {
  useEffect(
    () {
      final detector = IonScreenshotDetector()
        ..startListening((_) {
          callback();
        });
      return detector.dispose;
    },
    [callback],
  );
}
