// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/progress_bar/ice_loading_indicator.dart';
import 'package:ice/app/components/screen_offset/screen_bottom_offset.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/feed/create_story/hooks/use_camera_recording_controller.dart';
import 'package:ice/app/features/feed/create_story/hooks/use_recording_progress.dart';
import 'package:ice/app/features/feed/create_story/providers/story_camera_provider.dart';
import 'package:ice/app/features/feed/create_story/views/components/story_camera/components.dart';
import 'package:ice/app/features/gallery/providers/camera_provider.dart';

// TODO implement listening of app lifecycle state change
class StoryCameraWidget extends HookConsumerWidget {
  const StoryCameraWidget({super.key});

  static final maxRecordingDuration = 20.seconds;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cameraControllerAsync = ref.watch(cameraControllerNotifierProvider);
    final storyCameraState = ref.watch(storyCameraControllerProvider);

    final (recordingDuration, recordingProgress) = useRecordingProgress(
      ref,
      isRecording: storyCameraState.isRecording,
    );

    final (
      isCameraReady,
      handleRecordingStart,
      handleRecordingStop,
    ) = useCameraRecordingController(ref, context);

    return Scaffold(
      backgroundColor: context.theme.appColors.primaryText,
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: [
            cameraControllerAsync.maybeWhen(
              data: (controller) => controller != null
                  ? StoryCameraPreview(controller: controller)
                  : const Center(child: IceLoadingIndicator()),
              orElse: () => const Center(child: IceLoadingIndicator()),
            ),
            if (storyCameraState.isRecording)
              RecordingIndicator(recordingDuration: recordingDuration)
            else
              const IdleCameraPreview(),
            Positioned.fill(
              bottom: 16.0.s,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: CaptureButton(
                  isRecording: storyCameraState.isRecording,
                  recordingProgress: recordingProgress,
                  onRecordingStart: isCameraReady ? handleRecordingStart : null,
                  onRecordingStop: isCameraReady ? handleRecordingStop : null,
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
