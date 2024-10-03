// SPDX-License-Identifier: ice License 1.0

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:video_player/video_player.dart';

extension VideoPlayerControllerExtension on VideoPlayerController {
  /// Cross platform method to create `VideoPlayerController` instance from a local asset file.
  ///
  /// `video_player` lib does not support Windows platform,
  /// so using `https://pub.dev/packages/video_player_win` in addition.
  ///
  /// The web platform does not support `dart:io` and therefore does not support
  /// `VideoPlayerController.file` constructor.
  /// source: https://pub.dev/packages/video_player#web
  ///
  /// `video_player_win` in its turn doesn't support `VideoPlayerController.asset`.
  static VideoPlayerController fromFile(String path, {VideoPlayerOptions? options}) {
    if (!kIsWeb && Platform.isWindows) {
      return VideoPlayerController.file(File(path), videoPlayerOptions: options);
    }

    return VideoPlayerController.asset(path, videoPlayerOptions: options);
  }
}
