// SPDX-License-Identifier: ice License 1.0

import 'dart:io';

import 'package:cached_video_player_plus/cached_video_player_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/core/providers/mute_provider.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'video_player_provider.c.g.dart';

@immutable
class VideoControllerParams {
  const VideoControllerParams({
    required this.sourcePath,
    this.uniqueId = '',
    this.autoPlay = false,
    this.looping = false,
    this.options,
  });

  final String sourcePath;
  final String
      uniqueId; // an optional uniqueId parameter which should be used when needed independent controllers for the same sourcePath
  final VideoPlayerOptions? options;
  final bool autoPlay;
  final bool looping;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VideoControllerParams &&
          other.sourcePath == sourcePath &&
          other.uniqueId == uniqueId;

  @override
  int get hashCode => sourcePath.hashCode ^ uniqueId.hashCode;
}

@riverpod
Raw<CachedVideoPlayerPlusController> videoController(
  Ref ref,
  VideoControllerParams params,
) {
  final controller = ref
      .watch(videoPlayerControllerFactoryProvider(params.sourcePath))
      .createController(params.options);
  var isInitialized = false;

  void handleInitialized() {
    if (!isInitialized && controller.value.isInitialized) {
      isInitialized = true;
      controller.setLooping(params.looping);

      if (kIsWeb) {
        controller.setVolume(0); // required for web - https://developer.chrome.com/blog/autoplay/
      } else {
        final isMuted = ref.read(globalMuteProvider);
        controller.setVolume(isMuted ? 0 : 1);
      }

      if (params.autoPlay) {
        controller.play();
      }
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

  CachedVideoPlayerPlusController createController(VideoPlayerOptions? options) {
    final videoPlayerOptions = options ?? VideoPlayerOptions();

    if (_isNetworkSource(sourcePath)) {
      return CachedVideoPlayerPlusController.networkUrl(
        Uri.parse(sourcePath),
        videoPlayerOptions: videoPlayerOptions,
      );
    } else if (_isLocalFile(sourcePath)) {
      return CachedVideoPlayerPlusController.file(
        File(sourcePath),
        videoPlayerOptions: videoPlayerOptions,
      );
    }
    return CachedVideoPlayerPlusController.asset(
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
