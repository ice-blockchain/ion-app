// SPDX-License-Identifier: ice License 1.0

import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ion/app/features/feed/create_story/hooks/use_image_story_progress.dart';
import 'package:video_player/video_player.dart';

StoryProgress useVideoStoryProgress({
  required bool isCurrent,
  required VideoPlayerController? controller,
}) {
  final progressRef = useRef<double>(0);
  final isCompletedRef = useRef(false);
  final progress = useState<double>(0);

  final handleProgress = useCallback(
    () {
      if (!isCurrent || controller == null || !controller.value.isInitialized) {
        return;
      }

      final position = controller.value.position;
      final duration = controller.value.duration;

      if (duration.inMilliseconds > 0) {
        final currentProgress = (position.inMilliseconds / duration.inMilliseconds).clamp(0.0, 1.0);

        progressRef.value = currentProgress;
        progress.value = currentProgress;
        isCompletedRef.value = currentProgress >= 1.0;
      }
    },
    [isCurrent, controller],
  );

  useEffect(
    () {
      if (!isCurrent) {
        progressRef.value = 0.0;
        progress.value = 0.0;
        isCompletedRef.value = false;
        return null;
      }

      if (controller != null) {
        controller.addListener(handleProgress);
        return () => controller.removeListener(handleProgress);
      }

      return null;
    },
    [isCurrent, controller, handleProgress],
  );

  useEffect(
    () {
      if (controller != null) {
        controller
          ..pause()
          ..seekTo(Duration.zero);
      }
      return null;
    },
    const [],
  );

  return StoryProgress(
    progress: progress.value,
    isCompleted: isCompletedRef.value,
  );
}
