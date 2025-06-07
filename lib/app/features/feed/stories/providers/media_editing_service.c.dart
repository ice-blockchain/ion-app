// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/gallery/data/models/camera_state.c.dart';
import 'package:ion/app/features/gallery/providers/camera_provider.c.dart';
import 'package:ion/app/services/media_service/banuba_service.c.dart';
import 'package:ion/app/services/media_service/data/models/media_file.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'media_editing_service.c.g.dart';

@riverpod
MediaEditingService mediaEditingService(Ref ref) => MediaEditingService._(ref);

class MediaEditingService {
  const MediaEditingService._(this._ref);
  final Ref _ref;

  Future<String?> edit(MediaFile file, {bool resumeCamera = true}) async {
    final camera = _ref.read(cameraControllerNotifierProvider.notifier);
    final isCameraPaused = _ref.read(cameraControllerNotifierProvider) is CameraPaused;

    if (!isCameraPaused) await camera.pauseCamera();
    try {
      return await _ref.read(editMediaProvider(file).future);
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
