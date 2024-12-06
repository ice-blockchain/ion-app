// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/services.dart';
import 'package:ion_screenshot_detector/ion_screenshot_detector.dart';

class MethodChannelIonScreenshotDetector extends IonScreenshotDetectorPlatform {
  static const EventChannel _eventChannel = EventChannel('io.ion.app/screenshots');

  @override
  Stream<String> get onScreenshot {
    return _eventChannel.receiveBroadcastStream().cast<String>();
  }
}
