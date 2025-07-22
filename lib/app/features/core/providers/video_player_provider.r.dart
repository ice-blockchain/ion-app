// SPDX-License-Identifier: ice License 1.0

import 'dart:async';
import 'dart:io';

import 'package:cached_video_player_plus/cached_video_player_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/core/providers/ion_connect_media_url_fallback_provider.r.dart';
import 'package:ion/app/features/core/providers/mute_provider.r.dart';
import 'package:ion/app/services/logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:video_player/video_player.dart';

part 'video_player_provider.r.g.dart';

class NetworkVideosCacheManager {
  static const key = 'networkVideosCacheKey';

  static CacheManager instance = CacheManager(
    Config(
      key,
      maxNrOfCacheObjects: 100,
      stalePeriod: const Duration(days: 1),
    ),
  );
}

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
  CachedVideoPlayerPlus? _activePlayer;

  @override
  Future<Raw<VideoPlayerController>> build(VideoControllerParams params) async {
    final sourcePath = ref.watch(
      iONConnectMediaUrlFallbackProvider
          .select((state) => state[params.sourcePath] ?? params.sourcePath),
    );

    final player = ref
        .watch(videoPlayerControllerFactoryProvider(sourcePath))
        .createController(VideoPlayerOptions(mixWithOthers: true));

    ref.onCancel(() async {
      await Future.wait([
        () async {
          if (player.isInitialized) {
            await player.controller.dispose();
          }
        }(),
        () async {
          if (_activePlayer != null && _activePlayer != player && _activePlayer!.isInitialized) {
            await _activePlayer!.controller.dispose();
            _activePlayer = null;
          }
        }(),
      ]);
    });

    try {
      await player.initialize();
      final controller = player.controller;
      if (!controller.value.hasError) {
        await controller.setLooping(params.looping);

        // Set initial volume based on global mute state
        final isMuted = ref.read(globalMuteNotifierProvider);
        await controller.setVolume(isMuted ? 0.0 : 1.0);

        final prevController = _activePlayer != null && _activePlayer!.isInitialized
            ? _activePlayer!.controller
            : null;
        if (prevController != null) {
          final isPlaying = prevController.value.isBuffering || prevController.value.isPlaying;
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

        _activePlayer = player;

        ref.listen(globalMuteNotifierProvider, (_, muted) {
          final prevController = _activePlayer != null && _activePlayer!.isInitialized
              ? _activePlayer!.controller
              : null;
          if (prevController != null) {
            final isPlaying = prevController.value.isPlaying;
            unawaited(
              prevController.setVolume(muted ? 0.0 : 1.0).then((_) {
                if (isPlaying) {
                  prevController.play();
                }
              }),
            );
          }
        });
      }
    } catch (error, stackTrace) {
      final authorPubkey = params.authorPubkey;
      final controller = player.isInitialized ? player.controller : null;
      if (controller != null &&
          controller.dataSourceType == DataSourceType.network &&
          authorPubkey != null) {
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

    return player.controller;
  }
}

class VideoPlayerControllerFactory {
  const VideoPlayerControllerFactory({
    required this.sourcePath,
  });

  final String sourcePath;

  CachedVideoPlayerPlus createController(VideoPlayerOptions? options) {
    final videoPlayerOptions = options ?? VideoPlayerOptions();

    if (_isNetworkSource(sourcePath)) {
      return CachedVideoPlayerPlus.networkUrl(
        Uri.parse(sourcePath),
        videoPlayerOptions: videoPlayerOptions,
        cacheManager: NetworkVideosCacheManager.instance,
      );
    } else if (_isLocalFile(sourcePath)) {
      return CachedVideoPlayerPlus.file(
        File(sourcePath),
        videoPlayerOptions: videoPlayerOptions,
      );
    }
    return CachedVideoPlayerPlus.asset(
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
