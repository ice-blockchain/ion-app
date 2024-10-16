// SPDX-License-Identifier: ice License 1.0

import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/features/feed/create_story/providers/story_camera_provider.dart';

final Duration maxRecordingDuration = 20.seconds;

typedef RecordingProgressResult = (
  Duration recordingDuration,
  double recordingProgress,
);

/// A hook that manages the recording progress for a video recording feature.
///
/// This hook returns a tuple containing the current recording duration and the recording progress.
/// It uses an animation controller to track the recording progress and updates the recording
/// duration accordingly. When the recording is completed, it stops the video recording using
/// the provided `storyCameraControllerProvider`.
///
/// Parameters:
/// - ref: WidgetRef for accessing providers
/// - isRecording: A boolean indicating whether recording is in progress
///
/// Returns:
/// - A tuple containing the current recording duration and the recording progress.
RecordingProgressResult useRecordingProgress(
  WidgetRef ref, {
  required bool isRecording,
}) {
  final animationController = useAnimationController(duration: maxRecordingDuration);
  final currentRecordingDuration = useState<Duration>(Duration.zero);

  useEffect(
    () {
      if (isRecording) {
        animationController.forward(from: 0);
      } else {
        animationController.reset();
        currentRecordingDuration.value = Duration.zero;
      }

      void listener() {
        final updatedDuration = maxRecordingDuration * animationController.value;
        currentRecordingDuration.value = updatedDuration;

        if (animationController.isCompleted) {
          ref.read(storyCameraControllerProvider.notifier).stopVideoRecording();
        }
      }

      animationController.addListener(listener);

      return () => animationController.removeListener(listener);
    },
    [isRecording, animationController],
  );

  return (
    currentRecordingDuration.value,
    animationController.value,
  );
}
