// SPDX-License-Identifier: ice License 1.0

import 'dart:async';
import 'dart:io';

import 'package:ion/app/features/feed/stories/data/models/camera_capture_state.c.dart';
import 'package:ion/app/features/gallery/providers/camera_provider.c.dart';
import 'package:ion/app/features/gallery/providers/gallery_provider.c.dart';
import 'package:ion/app/services/media_service/media_service.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'camera_actions_provider.c.g.dart';

@riverpod
class CameraActionsController extends _$CameraActionsController {
  @override
  CameraCaptureState build() => const CameraCaptureState.initial();

  Future<void> takePhoto() async {
    final cameraNotifier = ref.read(cameraControllerNotifierProvider.notifier);
    
    try {
      final picture = await cameraNotifier.takePicture();

      if (picture != null) {
        await cameraNotifier.pauseCamera();
        
        final mediaFile = await ref.read(mediaServiceProvider).saveImageToGallery(File(picture.path));

        if (mediaFile != null) {
          ref.invalidate(latestGalleryPreviewProvider);
          state = CameraCaptureState.saved(file: mediaFile);
        } else {
          state = const CameraCaptureState.error(message: 'Failed to save photo.');
        }
      }
    } catch (e) {
      state = CameraCaptureState.error(message: 'Error taking photo: $e');
    }
  }

  Future<void> startVideoRecording() async {
    await ref.read(cameraControllerNotifierProvider.notifier).startVideoRecording();
    state = const CameraCaptureState.recording();
  }

  Future<void> stopVideoRecording() async {
    final cameraNotifier = ref.read(cameraControllerNotifierProvider.notifier);
    final videoFile = await cameraNotifier.stopVideoRecording();

    if (videoFile != null) {
      final mediaFile = await ref.read(mediaServiceProvider).saveVideoToGallery(videoFile.path);

      if (mediaFile != null) {
        state = CameraCaptureState.saved(file: mediaFile);
        await cameraNotifier.pauseCamera();
      }
    } else {
      state = const CameraCaptureState.error(message: 'Failed to stop video recording.');
    }
  }

  Future<void> toggleFlash() async {
    final cameraNotifier = ref.read(cameraControllerNotifierProvider.notifier);
    await cameraNotifier.toggleFlash();
  }

  void reset() => state = const CameraCaptureState.initial();
}
