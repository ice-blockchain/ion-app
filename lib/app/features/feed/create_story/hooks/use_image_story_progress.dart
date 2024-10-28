// SPDX-License-Identifier: ice License 1.0

import 'package:flutter_hooks/flutter_hooks.dart';

class StoryProgress {
  const StoryProgress({
    required this.progress,
    required this.isCompleted,
  });
  final double progress;
  final bool isCompleted;
}

StoryProgress useImageStoryProgress({
  required bool isCurrent,
  required Duration duration,
}) {
  final isCompletedRef = useRef(false);
  final progress = useState<double>(0);

  final animationController = useAnimationController(
    duration: duration,
  );

  final handleProgress = useCallback(
    () {
      if (!isCurrent) return;

      final currentProgress = animationController.value;
      progress.value = currentProgress;
      isCompletedRef.value = currentProgress >= 1.0;
    },
    [isCurrent, animationController],
  );

  useEffect(
    () {
      if (!isCurrent) {
        progress.value = 0.0;
        isCompletedRef.value = false;
        return null;
      }

      animationController
        ..reset()
        ..forward()
        ..addListener(handleProgress);

      return () {
        animationController
          ..removeListener(handleProgress)
          ..reset();
      };
    },
    [isCurrent, handleProgress, animationController],
  );

  return StoryProgress(
    progress: progress.value,
    isCompleted: isCompletedRef.value,
  );
}
