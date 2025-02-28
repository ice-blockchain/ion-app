// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:video_player/video_player.dart';

void useStoryCompletion({
  required AnimationController? imageController,
  required VideoPlayerController? videoController,
  required VoidCallback onCompleted,
}) {
  useEffect(
    () {
      if (imageController != null) {
        void checkPhotoCompletion() {
          if (imageController.isCompleted) {
            onCompleted();
          }
        }

        imageController.addListener(checkPhotoCompletion);
        return () => imageController.removeListener(checkPhotoCompletion);
      }
      return null;
    },
    [imageController],
  );

  useEffect(
    () {
      if (videoController == null) return null;

      void checkVideoCompletion() {
        final controller = videoController.value;
        if (controller.isInitialized &&
            controller.duration > Duration.zero &&
            controller.position >= controller.duration) {
          onCompleted();
        }
      }

      videoController.addListener(checkVideoCompletion);
      return () => videoController.removeListener(checkVideoCompletion);
    },
    [videoController],
  );
}
