// SPDX-License-Identifier: ice License 1.0

import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/feed/create_story/providers/story_camera_provider.dart';
import 'package:ion/app/features/gallery/providers/camera_provider.dart';

typedef RecordingHandlers = (
  bool isCameraReady,
  Future<void> Function() handleRecordingStart,
  Future<String?> Function() handleRecordingStop,
);

/// Manages camera readiness and provides handlers to start/stop recording.
RecordingHandlers useCameraRecordingController(WidgetRef ref) {
  final cameraControllerAsync = ref.watch(cameraControllerNotifierProvider);
  final controller = cameraControllerAsync.value;

  final cameraValue = controller != null ? useValueListenable(controller) : null;

  final isCameraReady = cameraValue?.isInitialized ?? false;

  Future<void> handleRecordingStart() async {
    if (isCameraReady) {
      await ref.read(storyCameraControllerProvider.notifier).startVideoRecording();
    }
  }

  Future<String?> handleRecordingStop() async {
    if (isCameraReady) {
      final videoPath = await ref.read(storyCameraControllerProvider.notifier).stopVideoRecording();
      return videoPath;
    }
    return null;
  }

  return (
    isCameraReady,
    handleRecordingStart,
    handleRecordingStop,
  );
}
