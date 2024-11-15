// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/animation.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:video_player/video_player.dart';

void useStoryPause({
  required AnimationController progressController,
  required VideoPlayerController? videoController,
  required bool isPaused,
}) {
  useEffect(
    () {
      _handleImageProgress(isPaused, progressController);
      _handleVideoProgress(isPaused, videoController);
      return null;
    },
    [isPaused],
  );
}

void _handleImageProgress(bool isPaused, AnimationController controller) {
  if (isPaused) {
    controller.stop();
  } else {
    controller.forward();
  }
}

void _handleVideoProgress(bool isPaused, VideoPlayerController? controller) {
  if (controller == null) return;

  if (isPaused && controller.value.isPlaying) {
    controller.pause();
  } else if (!isPaused && !controller.value.isPlaying) {
    controller.play();
  }
}
