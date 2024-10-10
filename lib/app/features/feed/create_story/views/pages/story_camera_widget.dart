import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/progress_bar/ice_loading_indicator.dart';
import 'package:ice/app/components/screen_offset/screen_bottom_offset.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/feed/create_story/views/components/camera_control_button.dart';
import 'package:ice/app/features/feed/create_story/views/components/capture_button.dart';
import 'package:ice/app/features/feed/create_story/views/components/recording_indicator.dart';
import 'package:ice/app/features/gallery/providers/camera_provider.dart';
import 'package:ice/app/services/media_service/media_service.dart';
import 'package:ice/generated/assets.gen.dart';

class StoryCameraWidget extends HookConsumerWidget {
  const StoryCameraWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cameraControllerNotifier = ref.watch(cameraControllerNotifierProvider.notifier);
    final cameraControllerAsync = ref.watch(cameraControllerNotifierProvider);
    final mediaService = ref.watch(mediaServiceProvider);

    final isRecording = useState(false);
    final recordingDuration = useState(Duration.zero);
    final isFlashOn = useState(false);

    Future<void> startVideoRecording() async {
      if (!isRecording.value) {
        await cameraControllerNotifier.startVideoRecording();
        isRecording.value = true;
        recordingDuration.value = Duration.zero;
      }
    }

    Future<void> stopVideoRecording() async {
      if (isRecording.value) {
        final video = await cameraControllerNotifier.stopVideoRecording();
        if (video != null) {
          await mediaService.saveVideoToGallery(video.path);
        }
        isRecording.value = false;
        recordingDuration.value = Duration.zero;
      }
    }

    useEffect(
      () {
        Timer? timer;
        if (isRecording.value) {
          timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
            recordingDuration.value += const Duration(milliseconds: 100);
            if (recordingDuration.value.inSeconds >= 20) {
              stopVideoRecording();
            }
          });
        }
        return () => timer?.cancel();
      },
      [isRecording.value],
    );

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: [
            cameraControllerAsync.maybeWhen(
              data: (controller) => controller != null
                  ? _CameraPreviewWidget(controller: controller)
                  : const Center(
                      child: IceLoadingIndicator(),
                    ),
              orElse: () => const Center(
                child: IceLoadingIndicator(),
              ),
            ),
            if (!isRecording.value)
              Positioned(
                top: 10.0.s,
                left: 10.0.s,
                child: CameraControlButton(
                  icon: Assets.svg.iconSheetClose.icon(
                    color: Colors.white,
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            if (!isRecording.value)
              Positioned(
                top: 10.0.s,
                right: 10.0.s,
                child: CameraControlButton(
                  icon: Assets.svg.iconStoryLightning.icon(),
                  onPressed: () {
                    isFlashOn.value = !isFlashOn.value;
                    cameraControllerNotifier.setFlashMode(
                      isFlashOn.value ? FlashMode.torch : FlashMode.off,
                    );
                  },
                ),
              ),
            if (!isRecording.value)
              Positioned(
                bottom: 30.0.s,
                right: 16.0.s,
                child: CameraControlButton(
                  icon: Assets.svg.iconStorySwitchcamera.icon(),
                  onPressed: cameraControllerNotifier.switchCamera,
                ),
              ),
            if (!isRecording.value)
              Positioned(
                bottom: 30.0.s,
                left: 16.0.s,
                child: CameraControlButton(
                  icon: Assets.svg.iconGalleryOpen.icon(
                    color: Colors.white,
                  ),
                  onPressed: () {},
                ),
              ),
            if (isRecording.value)
              RecordingIndicator(
                recordingDuration: recordingDuration.value,
              ),
            Positioned.fill(
              bottom: 16.0.s,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: CaptureButton(
                  isRecording: isRecording.value,
                  recordingProgress: recordingDuration.value.inSeconds / 20,
                  onRecordingStart: startVideoRecording,
                  onRecordingStop: stopVideoRecording,
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

class _CameraPreviewWidget extends StatelessWidget {
  const _CameraPreviewWidget({
    required this.controller,
  });

  final CameraController controller;

  @override
  Widget build(BuildContext context) {
    if (!controller.value.isInitialized) {
      return const Center(child: IceLoadingIndicator());
    }

    final size = MediaQuery.sizeOf(context);
    final cameraAspectRatio = controller.value.aspectRatio;

    return ClipRRect(
      borderRadius: BorderRadius.circular(20.0.s),
      child: FittedBox(
        fit: BoxFit.cover,
        child: SizedBox(
          width: size.width,
          height: size.width / cameraAspectRatio,
          child: Center(
            child: CameraPreview(controller),
          ),
        ),
      ),
    );
  }
}
