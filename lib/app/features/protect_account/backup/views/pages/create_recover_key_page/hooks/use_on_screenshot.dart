// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/foundation.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenshot_detect/flutter_screenshot_detect.dart';

void useOnScreenshot(VoidCallback callback) {
  useEffect(
    () {
      final detector = FlutterScreenshotDetect()
        ..startListening((_) {
          print('SCREENSHOT DETECTED ++++++++++++++++++++++++++++++');
          callback();
        });
      return detector.dispose;
    },
    [callback],
  );
}
