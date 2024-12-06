// SPDX-License-Identifier: ice License 1.0

import 'package:ion_screenshot_detector/ion_screenshot_detector.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

abstract class IonScreenshotDetectorPlatform extends PlatformInterface {
  /// Constructs a ScreenshotDetectorPlatform.
  IonScreenshotDetectorPlatform() : super(token: _token);

  static final Object _token = Object();

  static IonScreenshotDetectorPlatform _instance = MethodChannelIonScreenshotDetector();

  /// The default instance of [IonScreenshotDetectorPlatform] to use.
  ///
  /// Defaults to [MethodChannelIonScreenshotDetector].
  static IonScreenshotDetectorPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [IonScreenshotDetectorPlatform] when
  /// they register themselves.
  static set instance(IonScreenshotDetectorPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Stream<String> get onScreenshot {
    throw UnimplementedError('onScreenshot has not been implemented.');
  }
}
