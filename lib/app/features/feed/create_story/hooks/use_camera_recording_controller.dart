// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/features/feed/create_story/providers/story_camera_provider.dart';
import 'package:ice/app/features/gallery/providers/camera_provider.dart';
import 'package:ice/app/router/app_routes.dart';

typedef RecordingHandlers = (
  bool isCameraReady,
  Future<void> Function() handleRecordingStart,
  Future<void> Function() handleRecordingStop,
);

/// A custom hook that manages camera readiness and recording handlers for video recording.
///
/// This hook encapsulates the logic for checking camera readiness and provides
/// handlers for starting and stopping video recording. It watches the camera controller's
/// state and updates the readiness status accordingly.
///
/// Parameters:
/// - ref: WidgetRef for accessing providers
/// - context: BuildContext for navigation and UI-related operations
///
/// Returns:
/// A record containing:
/// - isCameraReady: A boolean indicating whether the camera is initialized and ready
/// - handleRecordingStart: A function to start video recording
/// - handleRecordingStop: A function to stop video recording and navigate to preview
RecordingHandlers useCameraRecordingController(WidgetRef ref, BuildContext context) {
  final cameraControllerAsync = ref.watch(cameraControllerNotifierProvider);
  final isCameraReady = useState(false);

  useEffect(
    () {
      isCameraReady.value =
          cameraControllerAsync.value != null && cameraControllerAsync.value!.value.isInitialized;
      return null;
    },
    [cameraControllerAsync.value],
  );

  Future<void> handleRecordingStart() async {
    if (isCameraReady.value) {
      await ref.read(storyCameraControllerProvider.notifier).startVideoRecording();
    }
  }

  Future<void> handleRecordingStop() async {
    if (isCameraReady.value) {
      final videoPath = await ref.read(storyCameraControllerProvider.notifier).stopVideoRecording();
      if (videoPath != null && context.mounted) {
        await StoryPreviewRoute(videoPath: videoPath).push<void>(context);
      }
    }
  }

  return (
    isCameraReady.value,
    handleRecordingStart,
    handleRecordingStop,
  );
}
