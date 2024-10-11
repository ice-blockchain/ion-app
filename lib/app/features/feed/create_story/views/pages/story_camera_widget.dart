import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/progress_bar/ice_loading_indicator.dart';
import 'package:ice/app/components/screen_offset/screen_bottom_offset.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/feed/create_story/providers/story_camera_provider.dart';
import 'package:ice/app/features/feed/create_story/views/components/components.dart';
import 'package:ice/app/features/gallery/providers/camera_provider.dart';
import 'package:ice/generated/assets.gen.dart';

class StoryCameraWidget extends HookConsumerWidget {
  const StoryCameraWidget({super.key});

  static final maxRecordingDuration = 20.seconds;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cameraControllerAsync = ref.watch(cameraControllerNotifierProvider);
    final storyCameraState = ref.watch(storyCameraNotifierProvider);
    final storyCameraNotifier = ref.read(storyCameraNotifierProvider.notifier);

    final animationController = useAnimationController(duration: maxRecordingDuration);
    final recordingDuration = useState<Duration>(Duration.zero);

    useEffect(
      () {
        if (storyCameraState.isRecording) {
          animationController.forward(from: 0);
        } else {
          animationController.reset();
          recordingDuration.value = Duration.zero;
        }

        void listener() {
          final currentDuration = maxRecordingDuration * animationController.value;

          recordingDuration.value = currentDuration;

          if (animationController.isCompleted) {
            storyCameraNotifier.stopVideoRecording();
          }
        }

        animationController.addListener(listener);

        return () {
          animationController.removeListener(listener);
        };
      },
      [storyCameraState.isRecording, animationController, storyCameraNotifier],
    );

    Future<void> startRecording() async => storyCameraNotifier.startVideoRecording();
    Future<void> stopRecording() async => storyCameraNotifier.stopVideoRecording();

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
                  onPressed: () => context.pop(),
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
                recordingDuration: recordingDuration.value,
              ),
            Positioned.fill(
              bottom: 16.0.s,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: CaptureButton(
                  isRecording: storyCameraState.isRecording,
                  recordingProgress: animationController.value,
                  onRecordingStart: startRecording,
                  onRecordingStop: stopRecording,
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
