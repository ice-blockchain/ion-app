// SPDX-License-Identifier: ice License 1.0

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:video_player/video_player.dart';

part 'video_player_provider.c.g.dart';

@riverpod
Raw<VideoPlayerController> videoController(
  Ref ref,
  String sourcePath, {
  bool autoPlay = false,
  bool looping = false,
}) {
  final controller = ref.read(videoPlayerControllerFactoryProvider(sourcePath)).createController();
  var isInitialized = false;

  void handleInitialized() {
    if (!isInitialized && controller.value.isInitialized) {
      isInitialized = true;
      controller
        ..setLooping(looping)
        ..setVolume(0); // required for web - https://developer.chrome.com/blog/autoplay/
      if (autoPlay) controller.play();
      ref.notifyListeners();
    }
  }

  controller
    ..addListener(handleInitialized)
    ..initialize();

  ref.onDispose(() async {
    controller.removeListener(handleInitialized);
    await controller.dispose();
  });

  return controller;
}

class VideoPlayerControllerFactory {
  const VideoPlayerControllerFactory({
    required this.sourcePath,
  });

  final String sourcePath;

  VideoPlayerController createController() {
    final videoPlayerOptions = VideoPlayerOptions(mixWithOthers: true);

    if (_isNetworkSource(sourcePath)) {
      return VideoPlayerController.networkUrl(
        Uri.parse(sourcePath),
        videoPlayerOptions: videoPlayerOptions,
      );
    } else if (_isLocalFile(sourcePath)) {
      return VideoPlayerController.file(
        File(sourcePath),
        videoPlayerOptions: videoPlayerOptions,
      );
    }
    return VideoPlayerController.asset(
      sourcePath,
      videoPlayerOptions: videoPlayerOptions,
    );
  }

  bool _isNetworkSource(String path) {
    return path.startsWith('http://') || path.startsWith('https://');
  }

  bool _isLocalFile(String path) {
    return !kIsWeb && File(path).existsSync();
  }
}

@riverpod
VideoPlayerControllerFactory videoPlayerControllerFactory(Ref ref, String sourcePath) {
  return VideoPlayerControllerFactory(
    sourcePath: sourcePath,
  );
}

/// A provider that manages the currently active video in the feed.
/// Only one video can be active at a time to prevent multiple videos
/// from playing simultaneously.
@riverpod
class ActiveVideo extends _$ActiveVideo {
  @override
  String? build() => null;

  set activeVideo(String? videoId) => state = videoId;
}
