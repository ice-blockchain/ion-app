// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ion/app/services/logger/logger.dart';
import 'package:video_player/video_player.dart';

void useStoryCompletion({
  required bool isCurrent,
  required AnimationController? imageController,
  required VideoPlayerController? videoController,
  required VoidCallback onCompleted,
}) {
  final completedRef = useRef(false);

  final checkPhotoCompletion = useCallback(
    () {
      if ((imageController?.isCompleted ?? false) && !completedRef.value && isCurrent) {
        Logger.info('Image story completed: isCompleted=${imageController!.isCompleted}');
        completedRef.value = true;
        onCompleted();
      }
    },
    [imageController, isCurrent, onCompleted],
  );

  final checkVideoCompletion = useCallback(
    () {
      if (videoController == null) return;

      final controller = videoController.value;
      if (controller.isInitialized &&
          controller.duration > Duration.zero &&
          controller.position >= controller.duration &&
          !completedRef.value &&
          isCurrent) {
        Logger.info(
          'Video story completed: position=${controller.position}, duration=${controller.duration}',
        );
        completedRef.value = true;
        onCompleted();
      }
    },
    [videoController, isCurrent, onCompleted],
  );

  useEffect(
    () {
      if (imageController != null) {
        imageController.addListener(checkPhotoCompletion);
        return () => imageController.removeListener(checkPhotoCompletion);
      }
      return null;
    },
    [imageController, checkPhotoCompletion],
  );

  useEffect(
    () {
      if (videoController != null) {
        videoController.addListener(checkVideoCompletion);
        return () => videoController.removeListener(checkVideoCompletion);
      }
      return null;
    },
    [videoController, checkVideoCompletion],
  );
}
