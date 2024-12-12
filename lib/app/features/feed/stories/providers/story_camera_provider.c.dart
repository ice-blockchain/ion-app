// SPDX-License-Identifier: ice License 1.0

import 'dart:async';
import 'dart:io';

import 'package:ion/app/features/feed/stories/data/models/story_camera_state.c.dart';
import 'package:ion/app/features/gallery/providers/camera_provider.c.dart';
import 'package:ion/app/features/gallery/providers/gallery_provider.c.dart';
import 'package:ion/app/services/media_service/media_service.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'story_camera_provider.c.g.dart';

@riverpod
class StoryCameraController extends _$StoryCameraController {
  @override
  StoryCameraState build() => const StoryCameraState.initial();

  Future<void> takePhoto() async {
    final cameraNotifier = ref.read(cameraControllerNotifierProvider.notifier);
    final picture = await cameraNotifier.takePicture();

    if (picture != null) {
      final mediaFile = await ref.read(mediaServiceProvider).saveImageToGallery(File(picture.path));

      if (mediaFile != null) {
        ref.invalidate(latestGalleryPreviewProvider);
        state = StoryCameraState.saved(file: mediaFile);
      } else {
        state = const StoryCameraState.error(message: 'Failed to save photo.');
      }
    }
  }

  Future<void> startVideoRecording() async {
    await ref.read(cameraControllerNotifierProvider.notifier).startVideoRecording();
    state = const StoryCameraState.recording();
  }

  Future<void> stopVideoRecording() async {
    final cameraNotifier = ref.read(cameraControllerNotifierProvider.notifier);
    final videoFile = await cameraNotifier.stopVideoRecording();

    if (videoFile != null) {
      final mediaFile = await ref.read(mediaServiceProvider).saveVideoToGallery(videoFile.path);

      if (mediaFile != null) {
        state = StoryCameraState.saved(file: mediaFile);
      }
    } else {
      state = const StoryCameraState.error(message: 'Failed to stop video recording.');
    }
  }

  Future<void> publishStory() async {
    state = const StoryCameraState.uploading();
    await Future<void>.delayed(const Duration(seconds: 2));

    state = const StoryCameraState.published();
  }

  Future<void> toggleFlash() async {
    final cameraNotifier = ref.read(cameraControllerNotifierProvider.notifier);
    await cameraNotifier.toggleFlash();
  }

  void reset() => state = const StoryCameraState.initial();
}
