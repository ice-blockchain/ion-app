// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/progress_bar/ice_loading_indicator.dart';
import 'package:ion/app/components/screen_offset/screen_bottom_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/create_story/hooks/use_camera_recording_controller.dart';
import 'package:ion/app/features/feed/create_story/hooks/use_recording_progress.dart';
import 'package:ion/app/features/feed/create_story/providers/story_camera_provider.dart';
import 'package:ion/app/features/feed/create_story/views/components/story_camera/components.dart';
import 'package:ion/app/features/gallery/providers/camera_provider.dart';
import 'package:ion/app/router/app_routes.dart';

// TODO implement listening of app lifecycle state change
class StoryCameraWidget extends HookConsumerWidget {
  const StoryCameraWidget({super.key});

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
    ) = useCameraRecordingController(ref);

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
                  onRecordingStop: isCameraReady
                      ? () async {
                          final videoPath = await handleRecordingStop();
                          if (videoPath != null && context.mounted) {
                            await StoryPreviewRoute(videoPath: videoPath).push<void>(context);
                          }
                        }
                      : null,
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
