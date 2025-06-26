// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/progress_bar/centered_loading_indicator.dart';
import 'package:ion/app/components/screen_offset/screen_bottom_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/stories/data/models/camera_capture_state.f.dart';
import 'package:ion/app/features/feed/stories/hooks/use_recording_progress.dart';
import 'package:ion/app/features/feed/stories/providers/camera_capture_provider.r.dart';
import 'package:ion/app/features/feed/stories/views/components/story_capture/camera/camera_idle_preview.dart';
import 'package:ion/app/features/feed/stories/views/components/story_capture/camera/custom_camera_preview.dart';
import 'package:ion/app/features/feed/stories/views/components/story_capture/controls/camera_capture_button.dart';
import 'package:ion/app/features/feed/stories/views/components/story_capture/controls/camera_recording_indicator.dart';
import 'package:ion/app/features/gallery/data/models/camera_state.f.dart';
import 'package:ion/app/features/gallery/providers/camera_provider.r.dart';
import 'package:ion/app/features/gallery/views/pages/media_picker_type.dart';

class GalleryCameraPage extends HookConsumerWidget {
  const GalleryCameraPage({
    required this.type,
    super.key,
  });

  final MediaPickerType type;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cameraState = ref.watch(cameraControllerNotifierProvider);

    ref.listen<CameraCaptureState>(
      cameraCaptureControllerProvider,
      (_, next) {
        next.whenOrNull(
          saved: (file) {
            if (context.mounted) context.pop(file);
          },
        );
      },
    );

    final isRecording = cameraState.maybeWhen(
      ready: (_, isRecording, __) => isRecording,
      orElse: () => false,
    );

    final (recordingDuration, recordingProgress) = useRecordingProgress(
      ref,
      isRecording: isRecording,
    );

    final captureNotifier = ref.read(cameraCaptureControllerProvider.notifier);
    final isCameraReady = cameraState is CameraReady;

    final capturePhotoAction = isCameraReady ? captureNotifier.takePhoto : null;
    final startVideoAction = isCameraReady ? captureNotifier.startVideoRecording : null;
    final stopVideoAction = isCameraReady ? captureNotifier.stopVideoRecording : null;

    final (onCapturePhoto, onRecordingStart, onRecordingStop) = switch (type) {
      MediaPickerType.image => (capturePhotoAction, null, null),
      MediaPickerType.video => (null, startVideoAction, stopVideoAction),
      MediaPickerType.common => (capturePhotoAction, startVideoAction, stopVideoAction),
    };

    return Scaffold(
      backgroundColor: context.theme.appColors.primaryText,
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: [
            cameraState.maybeWhen(
              ready: (controller, _, __) => CustomCameraPreview(controller: controller),
              orElse: () => const CenteredLoadingIndicator(),
            ),
            if (isRecording)
              CameraRecordingIndicator(recordingDuration: recordingDuration)
            else
              CameraIdlePreview(
                showGalleryButton: false,
                onGallerySelected: (_) async {},
              ),
            Positioned.fill(
              bottom: 16.0.s,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: CameraCaptureButton(
                  isRecording: isRecording,
                  recordingProgress: recordingProgress,
                  onCapturePhoto: onCapturePhoto,
                  onRecordingStart: onRecordingStart,
                  onRecordingStop: onRecordingStop,
                ),
              ),
            ),
            ScreenBottomOffset(margin: 42.0.s),
          ],
        ),
      ),
    );
  }
}
