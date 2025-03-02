// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/animation.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class UseImageStoryResult {
  UseImageStoryResult({required this.controller});
  final AnimationController controller;
}

UseImageStoryResult useImageStoryProgress({
  required bool isImage,
  required String storyId,
  required bool isCurrent,
  required bool isPaused,
  required VoidCallback onCompleted,
}) {
  final animationController = useAnimationController(
    duration: const Duration(seconds: 5),
    keys: [storyId],
  );

  final wasCurrentRef = useRef<bool>(false);

  useEffect(
    () {
      if (isImage) {
        animationController.reset();
      }
      return null;
    },
    [isImage, storyId],
  );

  useEffect(
    () {
      if (!isImage) return null;

      final justBecameCurrent = isCurrent && !wasCurrentRef.value;
      final becameInactive = !isCurrent && wasCurrentRef.value;

      wasCurrentRef.value = isCurrent;

      if (justBecameCurrent) {
        animationController
          ..reset()
          ..forward(from: 0);
      } else if (becameInactive) {
        if (animationController.isAnimating || animationController.value > 0) {
          animationController
            ..reset()
            ..stop();
        }
      }

      if (isCurrent) {
        if (isPaused) {
          animationController.stop();
        } else if (!animationController.isAnimating) {
          animationController.forward();
        }
      }
      return null;
    },
    [isImage, isCurrent, isPaused],
  );

  useEffect(
    () {
      if (!isImage) return null;

      void statusListener(AnimationStatus status) {
        if (status == AnimationStatus.completed && isCurrent) {
          onCompleted();
        }
      }

      animationController.addStatusListener(statusListener);
      return () => animationController.removeStatusListener(statusListener);
    },
    [isImage, animationController, isCurrent, onCompleted],
  );

  return UseImageStoryResult(controller: animationController);
}
