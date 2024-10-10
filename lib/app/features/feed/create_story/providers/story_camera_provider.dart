import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:ice/app/features/feed/create_story/data/models/story_camera_state.dart';
import 'package:ice/app/features/gallery/providers/camera_provider.dart';
import 'package:ice/app/services/media_service/media_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'story_camera_provider.g.dart';

@riverpod
class StoryCameraNotifier extends _$StoryCameraNotifier {
  Timer? _timer;

  @override
  StoryCameraState build() {
    ref.onDispose(() {
      _timer?.cancel();
    });

    return const StoryCameraState();
  }

  Future<void> startVideoRecording() async {
    if (!state.isRecording) {
      await ref.read(cameraControllerNotifierProvider.notifier).startVideoRecording();

      state = state.copyWith(isRecording: true);
      _startTimer();
    }
  }

  Future<void> stopVideoRecording() async {
    if (state.isRecording) {
      final video = await ref.read(cameraControllerNotifierProvider.notifier).stopVideoRecording();

      if (video != null) {
        await ref.read(mediaServiceProvider).saveVideoToGallery(video.path);
      }

      _stopTimer();

      state = state.copyWith(
        isRecording: false,
        recordingDuration: Duration.zero,
      );
    }
  }

  void toggleFlash() {
    final newFlashState = !state.isFlashOn;
    state = state.copyWith(isFlashOn: newFlashState);

    ref.read(cameraControllerNotifierProvider.notifier).setFlashMode(
          newFlashState ? FlashMode.torch : FlashMode.off,
        );
  }

  void _startTimer() {
    _timer = Timer.periodic(100.milliseconds, (timer) {
      final newDuration = state.recordingDuration + 100.milliseconds;

      newDuration.inSeconds >= 20
          ? stopVideoRecording()
          : state = state.copyWith(
              recordingDuration: newDuration,
            );
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
  }
}
