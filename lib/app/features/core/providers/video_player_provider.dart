// SPDX-License-Identifier: ice License 1.0

import 'package:ice/app/extensions/extensions.dart';
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
  final controller = VideoPlayerControllerExtension.fromFile(assetPath);

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
