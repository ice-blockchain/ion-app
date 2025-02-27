// SPDX-License-Identifier: ice License 1.0

import 'package:cached_video_player_plus/cached_video_player_plus.dart';
import 'package:flutter/animation.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

void useStoryPause({
  required AnimationController? imageController,
  required CachedVideoPlayerPlusController? videoController,
  required bool isPaused,
}) {
  useEffect(
    () {
      if (imageController != null) {
        if (isPaused) {
          imageController.stop();
        } else if (!imageController.isAnimating) {
          imageController.forward();
        }
      }

      if (videoController != null) {
        final controller = videoController.value;
        if (isPaused && controller.isPlaying) {
          videoController.pause();
        } else if (!isPaused && !controller.isPlaying) {
          videoController.play();
        }
      }

      return null;
    },
    [isPaused, imageController, videoController],
  );
}
