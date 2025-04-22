// SPDX-License-Identifier: ice License 1.0

import 'dart:async';
import 'dart:io';

import 'package:cached_video_player_plus/cached_video_player_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/core/providers/ion_connect_media_url_fallback_provider.c.dart';
import 'package:ion/app/features/core/providers/mute_provider.c.dart';
import 'package:ion/app/services/logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'video_player_provider.c.g.dart';

@immutable
class VideoControllerParams {
  const VideoControllerParams({
    required this.sourcePath,
    this.authorPubkey,
    this.uniqueId = '',
    this.autoPlay = false,
    this.looping = false,
  });

  final String sourcePath;
  final String? authorPubkey;
  final String
      uniqueId; // an optional uniqueId parameter which should be used when needed independent controllers for the same sourcePath
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
class VideoController extends _$VideoController {
  CachedVideoPlayerPlusController? _activeController;

  @override
  Future<Raw<CachedVideoPlayerPlusController>> build(VideoControllerParams params) async {
    final isMuted = ref.watch(globalMuteProvider);

    final sourcePath = ref.watch(
      iONConnectMediaUrlFallbackProvider
          .select((state) => state[params.sourcePath] ?? params.sourcePath),
    );

    final controller = ref
        .watch(videoPlayerControllerFactoryProvider(sourcePath))
        .createController(VideoPlayerOptions(mixWithOthers: isMuted));

    try {
      await controller.initialize();
      if (!controller.value.hasError) {
        await Future.wait(
          [controller.setLooping(params.looping), controller.setVolume(isMuted ? 0 : 1)],
        );

        if (_activeController != null) {
          final prevController = _activeController!;
          final isPlaying = prevController.value.isLooping ||
              prevController.value.isBuffering ||
              prevController.value.isPlaying;
          await controller.seekTo(prevController.value.position);
          if (isPlaying) {
            unawaited(controller.play());
          }
          WidgetsBinding.instance.addPostFrameCallback(
            (_) {
              prevController.dispose();
            },
          );
        } else {
          if (params.autoPlay) {
            unawaited(controller.play());
          }
        }

        _activeController = controller;
      }
    } catch (error, stackTrace) {
      final authorPubkey = params.authorPubkey;
      if (controller.dataSourceType == DataSourceType.network && authorPubkey != null) {
        await ref
            .watch(iONConnectMediaUrlFallbackProvider.notifier)
            .generateFallback(params.sourcePath, authorPubkey: authorPubkey);
      }
      Logger.log(
        'Error during video controller initialisation for source: ${params.sourcePath}',
        error: error,
        stackTrace: stackTrace,
      );
    }

    ref.onCancel(() async {
      return controller.dispose();
    });

    return controller;
  }
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
