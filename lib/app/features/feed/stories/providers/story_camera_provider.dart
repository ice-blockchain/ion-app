// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/feed/content_notificaiton/data/models/content_notification_data.dart';
import 'package:ion/app/features/feed/content_notificaiton/providers/content_notification_provider.dart';
import 'package:ion/app/features/feed/stories/data/models/story_camera_state.dart';
import 'package:ion/app/features/gallery/providers/camera_provider.dart';
import 'package:ion/app/features/gallery/providers/gallery_provider.dart';
import 'package:ion/app/services/media_service/media_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'story_camera_provider.g.dart';

@riverpod
class StoryCameraController extends _$StoryCameraController {
  @override
  StoryCameraState build() => const StoryCameraState.initial();

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
        state = StoryCameraState.saved(videoPath: mediaFile.path);
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

@riverpod
Future<String?> assetFilePath(Ref ref, String assetId) async {
  final assetEntity = await ref.watch(assetEntityProvider(assetId).future);

  if (assetEntity == null) return null;

  final file = await assetEntity.file;

  return file?.path;
}
