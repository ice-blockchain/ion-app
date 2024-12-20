// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/progress_bar/centered_loading_indicator.dart';
import 'package:ion/app/components/screen_offset/screen_bottom_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/stories/data/models/camera_capture_state.c.dart';
import 'package:ion/app/features/feed/stories/hooks/use_recording_progress.dart';
import 'package:ion/app/features/feed/stories/providers/camera_actions_provider.c.dart';
import 'package:ion/app/features/feed/stories/views/components/story_capture/camera/custom_camera_preview.dart';
import 'package:ion/app/features/feed/stories/views/components/story_capture/camera/camera_idle_preview.dart';
import 'package:ion/app/features/feed/stories/views/components/story_capture/controls/camera_capture_button.dart';
import 'package:ion/app/features/feed/stories/views/components/story_capture/controls/camera_recording_indicator.dart';
import 'package:ion/app/features/gallery/data/models/camera_state.c.dart';
import 'package:ion/app/features/gallery/providers/camera_provider.c.dart';
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
      cameraActionsControllerProvider,
      (_, next) => next.whenOrNull(
        saved: (file) {
          if (context.mounted) {
            context.pop(file);
          }
          return null;
        },
      ),
    );

    final isRecording = cameraState.maybeWhen(
      ready: (_, isRecording, __) => isRecording,
      orElse: () => false,
    );

    final (recordingDuration, recordingProgress) = useRecordingProgress(
      ref,
      isRecording: isRecording,
    );

    final isCameraReady = cameraState is CameraReady;

    final storyCameraNotifier = ref.read(cameraActionsControllerProvider.notifier);

    final capturePhotoAction = isCameraReady ? storyCameraNotifier.takePhoto : null;
    final startVideoAction = isCameraReady ? storyCameraNotifier.startVideoRecording : null;
    final stopVideoAction = isCameraReady ? storyCameraNotifier.stopVideoRecording : null;

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
              const CameraIdlePreview(showGalleryButton: false),
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
