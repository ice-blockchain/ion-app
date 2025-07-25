// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/feed/constants/video_constants.dart';
import 'package:ion/app/features/gallery/data/models/camera_state.f.dart';
import 'package:ion/app/features/gallery/providers/camera_provider.r.dart';
import 'package:ion/app/services/media_service/banuba_service.r.dart';
import 'package:ion/app/services/media_service/media_service.m.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'media_editing_service.r.g.dart';

@riverpod
MediaEditingService mediaEditingService(Ref ref) => MediaEditingService._(ref);

class MediaEditingService {
  const MediaEditingService._(this._ref);

  final Ref _ref;

  Future<String?> edit(
    MediaFile file, {
    bool resumeCamera = true,
    bool videoCoverSelectionEnabled = true,
  }) async {
    final camera = _ref.read(cameraControllerNotifierProvider.notifier);
    final isCameraPaused = _ref.read(cameraControllerNotifierProvider) is CameraPaused;

    if (!isCameraPaused) await camera.pauseCamera();
    try {
      return (await _ref.read(
        editMediaProvider(
          file,
          maxVideoDuration: VideoConstants.storyVideoMaxDuration,
          videoCoverSelectionEnabled: videoCoverSelectionEnabled,
        ).future,
      ))
          ?.path;
    } finally {
      if (resumeCamera && !isCameraPaused) await camera.resumeCamera();
    }
  }

  Future<String?> editExternalPhoto(
    String filePath, {
    bool resumeCamera = true,
  }) async {
    final camera = _ref.read(cameraControllerNotifierProvider.notifier);
    final isCameraPaused = _ref.read(cameraControllerNotifierProvider) is CameraPaused;

    if (!isCameraPaused) await camera.pauseCamera();
    try {
      return await _ref.read(banubaServiceProvider).editPhoto(filePath);
    } finally {
      if (resumeCamera && !isCameraPaused) await camera.resumeCamera();
    }
  }
}
