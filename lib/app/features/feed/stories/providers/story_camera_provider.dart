// SPDX-License-Identifier: ice License 1.0

import 'dart:async';
import 'dart:io';

import 'package:ion/app/features/feed/content_notification/data/models/content_notification_data.dart';
import 'package:ion/app/features/feed/content_notification/providers/content_notification_provider.dart';
import 'package:ion/app/features/feed/stories/data/models/story_camera_state.dart';
import 'package:ion/app/features/gallery/providers/camera_provider.dart';
import 'package:ion/app/services/media_service/media_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'story_camera_provider.g.dart';

@riverpod
class StoryCameraController extends _$StoryCameraController {
  @override
  StoryCameraState build() => const StoryCameraState.initial();

  Future<void> takePhoto() async {
    final cameraNotifier = ref.read(cameraControllerNotifierProvider.notifier);
    final picture = await cameraNotifier.takePicture();

    if (picture != null) {
      final mediaFile = await ref.read(mediaServiceProvider).saveImageToGallery(File(picture.path));

      state = mediaFile != null
          ? StoryCameraState.saved(file: mediaFile)
          : const StoryCameraState.error(message: 'Failed to save photo.');
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

    final notificationController = ref.read(contentNotificationControllerProvider.notifier)
      ..showLoading(ContentType.story);

    await Future<void>.delayed(const Duration(seconds: 2));

    state = const StoryCameraState.published();

    notificationController.showPublished(ContentType.story);
  }

  Future<void> toggleFlash() async {
    final cameraNotifier = ref.read(cameraControllerNotifierProvider.notifier);
    await cameraNotifier.toggleFlash();
  }

  void reset() => state = const StoryCameraState.initial();
}
