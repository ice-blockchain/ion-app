// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:camera/camera.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/feed/create_story/data/models/story_camera_state.dart';
import 'package:ion/app/features/gallery/providers/camera_provider.dart';
import 'package:ion/app/features/gallery/providers/gallery_provider.dart';
import 'package:ion/app/services/media_service/media_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'story_camera_provider.g.dart';

@riverpod
class StoryCameraController extends _$StoryCameraController {
  @override
  StoryCameraState build() => const StoryCameraState();

  Future<void> startVideoRecording() async {
    if (!state.isRecording) {
      final cameraController = ref.read(cameraControllerNotifierProvider).value;
      if (cameraController != null && cameraController.value.isInitialized) {
        await ref.read(cameraControllerNotifierProvider.notifier).startVideoRecording();
        state = state.copyWith(isRecording: true);
      }
    }
  }

  Future<String?> stopVideoRecording() async {
    if (state.isRecording) {
      final video = await ref.read(cameraControllerNotifierProvider.notifier).stopVideoRecording();

      if (video != null) {
        final mediaFile = await ref.read(mediaServiceProvider).saveVideoToGallery(video.path);
        state = state.copyWith(isRecording: false);

        if (mediaFile != null) {
          return mediaFile.path;
        }
      }

      state = state.copyWith(isRecording: false);
    }

    return null;
  }

  void toggleFlash() {
    final newFlashState = !state.isFlashOn;
    state = state.copyWith(isFlashOn: newFlashState);

    ref.read(cameraControllerNotifierProvider.notifier).setFlashMode(
          newFlashState ? FlashMode.torch : FlashMode.off,
        );
  }

  void publishStory() => state = state.copyWith(isStoryPublished: true);

  // TODO: Refactor this method when backend is ready for video upload.
  // This should be replaced with actual video upload logic and
  // the flag should be reset only after successful upload confirmation.
  void resetStoryPublished() => state = state.copyWith(isStoryPublished: false);
}

@riverpod
Future<String?> assetFilePath(Ref ref, String assetId) async {
  final assetEntity = await ref.watch(assetEntityProvider(assetId).future);

  if (assetEntity == null) return null;

  final file = await assetEntity.file;

  return file?.path;
}
