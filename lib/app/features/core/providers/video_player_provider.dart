// SPDX-License-Identifier: ice License 1.0

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:video_player/video_player.dart';

part 'video_player_provider.g.dart';

@riverpod
Raw<VideoPlayerController> videoController(
  Ref ref,
  String sourcePath, {
  bool autoPlay = false,
  bool looping = false,
}) {
  final controller = ref.read(videoPlayerControllerFactoryProvider).createController(sourcePath);

  controller.initialize().then((_) {
    ref.notifyListeners();
    controller
      ..setLooping(looping)
      ..setVolume(0); // required for web - https://developer.chrome.com/blog/autoplay/
    if (autoPlay) controller.play();
  });

  ref.onDispose(controller.dispose);

  return controller;
}

class VideoPlayerControllerFactory {
  VideoPlayerController createController(String sourcePath) {
    if (_isNetworkSource(sourcePath)) {
      return VideoPlayerController.networkUrl(Uri.parse(sourcePath));
    } else if (_isLocalFile(sourcePath)) {
      return VideoPlayerController.file(File(sourcePath));
    }
    return VideoPlayerController.asset(sourcePath);
  }

  bool _isNetworkSource(String path) {
    return path.startsWith('http://') || path.startsWith('https://');
  }

  bool _isLocalFile(String path) {
    return !kIsWeb && File(path).existsSync();
  }
}

@riverpod
VideoPlayerControllerFactory videoPlayerControllerFactory(Ref ref) {
  return VideoPlayerControllerFactory();
}
