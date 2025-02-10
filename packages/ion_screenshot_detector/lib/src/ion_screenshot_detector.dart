// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:flutter/services.dart';

class IonScreenshotDetector {
  static const EventChannel _eventChannel = EventChannel('io.ion.app/screenshots');

  Stream<String>? _screenshotStream;
  StreamSubscription<String>? _streamSubscription;

  Stream<String> get _onScreenshot {
    _screenshotStream ??=
        _eventChannel.receiveBroadcastStream().map((event) => event as String? ?? '');
    return _screenshotStream!;
  }

  void startListening(void Function(String event) onScreenshotTaken) {
    stopListening();
    _streamSubscription = _onScreenshot.listen(onScreenshotTaken);
  }

  void stopListening() {
    _streamSubscription?.cancel();
    _screenshotStream = null;
  }

  void dispose() {
    stopListening();
  }
}
