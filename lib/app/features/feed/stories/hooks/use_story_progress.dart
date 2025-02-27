// SPDX-License-Identifier: ice License 1.0

import 'package:cached_video_player_plus/cached_video_player_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ion/app/features/core/model/media_type.dart';
import 'package:ion/app/features/feed/data/models/entities/modifiable_post_data.c.dart';

class StoryProgress {
  const StoryProgress({
    required this.progress,
    required this.isCompleted,
  });

  final double progress;
  final bool isCompleted;
}

StoryProgress useStoryProgress({
  required ModifiablePostEntity post,
  required bool isCurrent,
  required bool isPaused,
  required CachedVideoPlayerPlusController? videoController,
}) {
  final progress = useState<double>(0);
  final isCompleted = useState(false);
  final animationController = useAnimationController(
    duration: const Duration(seconds: 5),
  );

  useEffect(
    () {
      progress.value = 0.0;
      isCompleted.value = false;
      animationController.reset();
      return null;
    },
    [post.id],
  );

  useEffect(
    () {
      if (!isCurrent) {
        progress.value = 0.0;
        isCompleted.value = false;
        animationController.reset();

        return null;
      }

      void handleProgress() {
        final media = post.data.primaryMedia;
        if (media == null) return;

        switch (media.mediaType) {
          case MediaType.image:
            _handleImageProgress(
              animationController,
              progress,
              isCompleted,
            );
          case MediaType.video:
            _handleVideoProgress(
              videoController,
              progress,
              isCompleted,
            );

          case MediaType.audio:
          case MediaType.unknown:
        }
      }

      final media = post.data.primaryMedia;
      if (media == null) return null;

      switch (media.mediaType) {
        case MediaType.image:
          return _setupAnimationController(
            animationController,
            handleProgress,
            isPaused,
          );
        case MediaType.video:
          return _setupVideoController(
            videoController,
            handleProgress,
            isCurrent,
            isPaused,
          );
        case MediaType.unknown || MediaType.audio:
      }
      return null;
    },
    [isCurrent, videoController, post.id, isPaused],
  );

  return StoryProgress(
    progress: progress.value,
    isCompleted: isCompleted.value,
  );
}

void _handleVideoProgress(
  CachedVideoPlayerPlusController? controller,
  ValueNotifier<double> progress,
  ValueNotifier<bool> isCompleted,
) {
  if (controller == null || !controller.value.isInitialized) return;

  final position = controller.value.position;
  final duration = controller.value.duration;

  if (duration.inMilliseconds > 0) {
    final currentProgress = (position.inMilliseconds / duration.inMilliseconds).clamp(0.0, 1.0);
    progress.value = currentProgress;
    isCompleted.value = currentProgress >= 1.0;
  }
}

void _handleImageProgress(
  AnimationController controller,
  ValueNotifier<double> progress,
  ValueNotifier<bool> isCompleted,
) {
  progress.value = controller.value;
  isCompleted.value = controller.value >= 1.0;
}

VoidCallback? _setupVideoController(
  CachedVideoPlayerPlusController? controller,
  VoidCallback handleProgress,
  bool isCurrent,
  bool isPaused,
) {
  if (controller == null) return null;

  controller.addListener(handleProgress);

  if (isCurrent && !isPaused) {
    if (!controller.value.isPlaying) {
      controller.play();
    }
  } else {
    controller.pause();
  }

  return () => controller.removeListener(handleProgress);
}

VoidCallback _setupAnimationController(
  AnimationController controller,
  VoidCallback handleProgress,
  bool isPaused,
) {
  controller.addListener(handleProgress);

  if (!controller.isAnimating && !isPaused) {
    if (controller.value == 0) {
      controller.forward();
    } else {
      controller.forward(from: controller.value);
    }
  } else if (isPaused) {
    controller.stop();
  }

  return () => controller.removeListener(handleProgress);
}
