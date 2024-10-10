import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/progress_bar/ice_loading_indicator.dart';
import 'package:ice/app/components/screen_offset/screen_bottom_offset.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/feed/create_story/providers/story_camera_provider.dart';
import 'package:ice/app/features/feed/create_story/views/components/camera_control_button.dart';
import 'package:ice/app/features/feed/create_story/views/components/capture_button.dart';
import 'package:ice/app/features/feed/create_story/views/components/recording_indicator.dart';
import 'package:ice/app/features/feed/create_story/views/components/story_camera_preview.dart';
import 'package:ice/app/features/gallery/providers/camera_provider.dart';
import 'package:ice/generated/assets.gen.dart';

class StoryCameraWidget extends ConsumerWidget {
  const StoryCameraWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cameraControllerAsync = ref.watch(cameraControllerNotifierProvider);
    final storyCameraState = ref.watch(storyCameraNotifierProvider);
    final storyCameraNotifier = ref.read(storyCameraNotifierProvider.notifier);

    return Scaffold(
      backgroundColor: Colors.black,
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
            if (!storyCameraState.isRecording)
              Positioned(
                top: 10.0.s,
                left: 10.0.s,
                child: CameraControlButton(
                  icon: Assets.svg.iconSheetClose.icon(color: Colors.white),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            if (!storyCameraState.isRecording)
              Positioned(
                top: 10.0.s,
                right: 10.0.s,
                child: CameraControlButton(
                  icon: Assets.svg.iconStoryLightning.icon(),
                  onPressed: storyCameraNotifier.toggleFlash,
                ),
              ),
            if (!storyCameraState.isRecording)
              Positioned(
                bottom: 30.0.s,
                right: 16.0.s,
                child: CameraControlButton(
                  icon: Assets.svg.iconStorySwitchcamera.icon(),
                  onPressed: () {
                    ref.read(cameraControllerNotifierProvider.notifier).switchCamera();
                  },
                ),
              ),
            if (!storyCameraState.isRecording)
              Positioned(
                bottom: 30.0.s,
                left: 16.0.s,
                child: CameraControlButton(
                  icon: Assets.svg.iconGalleryOpen.icon(color: Colors.white),
                  onPressed: () {},
                ),
              ),
            if (storyCameraState.isRecording)
              RecordingIndicator(
                recordingDuration: storyCameraState.recordingDuration,
              ),
            Positioned.fill(
              bottom: 16.0.s,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: CaptureButton(
                  isRecording: storyCameraState.isRecording,
                  recordingProgress: storyCameraState.recordingDuration.inSeconds / 20,
                  onRecordingStart: storyCameraNotifier.startVideoRecording,
                  onRecordingStop: storyCameraNotifier.stopVideoRecording,
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
