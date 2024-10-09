import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/progress_bar/ice_loading_indicator.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/feed/create_story/views/components/capture_button.dart';
import 'package:ice/app/features/gallery/providers/camera_provider.dart';
import 'package:ice/app/services/media_service/media_service.dart';

String formatDuration(Duration duration) {
  String twoDigits(int n) => n.toString().padLeft(2, '0');
  final minutes = twoDigits(duration.inMinutes.remainder(60));
  final seconds = twoDigits(duration.inSeconds.remainder(60));
  return '$minutes:$seconds';
}

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
      body: Stack(
        fit: StackFit.expand,
        children: [
          cameraControllerAsync.maybeWhen(
            data: (controller) => controller != null
                ? CameraPreview(controller)
                : const Center(
                    child: IceLoadingIndicator(),
                  ),
            orElse: () => const Center(
              child: IceLoadingIndicator(),
            ),
          ),
          if (!isRecording.value)
            Positioned(
              top: 40.0.s,
              left: 20.0.s,
              child: _buildIconButton(
                context: context,
                icon: Icons.close,
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          if (!isRecording.value)
            Positioned(
              top: 40.0.s,
              right: 20.0.s,
              child: Row(
                children: [
                  _buildIconButton(
                    context: context,
                    icon: isFlashOn.value ? Icons.flash_on : Icons.flash_off,
                    onPressed: () {
                      isFlashOn.value = !isFlashOn.value;
                      cameraControllerNotifier.setFlashMode(
                        isFlashOn.value ? FlashMode.torch : FlashMode.off,
                      );
                    },
                  ),
                ],
              ),
            ),
          if (!isRecording.value)
            Positioned(
              bottom: 40.0.s,
              right: 20.0.s,
              child: _buildIconButton(
                context: context,
                icon: Icons.flip_camera_ios,
                onPressed: cameraControllerNotifier.switchCamera,
              ),
            ),
          if (!isRecording.value)
            Positioned(
              bottom: 40.0.s,
              left: 20.0.s,
              child: _buildIconButton(
                context: context,
                icon: Icons.photo_library,
                onPressed: () {},
              ),
            ),
          if (isRecording.value)
            Positioned(
              top: 40.0.s,
              left: 0.0.s,
              right: 0.0.s,
              child: Center(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.0.s, vertical: 6.0.s),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(20.0.s),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.videocam, color: Colors.white, size: 18.0.s),
                      SizedBox(width: 4.0.s),
                      Text(
                        formatDuration(recordingDuration.value),
                        style: TextStyle(color: Colors.white, fontSize: 14.0.s),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(bottom: 42.0.s),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CaptureButton(
                    isRecording: isRecording.value,
                    recordingProgress: recordingDuration.value.inSeconds / 20,
                    onRecordingStart: startVideoRecording,
                    onRecordingStop: stopVideoRecording,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIconButton({
    required BuildContext context,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0.s),
        color: Colors.black.withOpacity(0.5),
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.white),
        onPressed: onPressed,
      ),
    );
  }
}
