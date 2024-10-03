// SPDX-License-Identifier: ice License 1.0

import 'dart:io';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:video_player/video_player.dart';

part 'video_player_provider.g.dart';

@riverpod
Raw<VideoPlayerController> videoController(
  VideoControllerRef ref,
  String assetPath, {
  bool autoPlay = false,
  bool looping = false,
}) {
  // VideoPlayerController.asset constructor is not supported on video_player_win
  final controller = VideoPlayerController.file(File(assetPath));

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
