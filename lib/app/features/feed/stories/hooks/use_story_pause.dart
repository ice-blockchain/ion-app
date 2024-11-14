// SPDX-License-Identifier: ice License 1.0
import 'package:flutter/animation.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/core/providers/video_player_provider.dart';

void useStoryPause({
  required bool isPaused, 
  required String? storyUrl,
  required AnimationController progressController,
  required WidgetRef ref,
}) {
  useEffect(
    () {
      _handleImageProgress(isPaused, progressController);
      _handleVideoProgress(isPaused, storyUrl, ref);
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

void _handleVideoProgress(bool isPaused, String? videoUrl, WidgetRef ref) {
  if (videoUrl == null) return;

  final controller = ref.read(videoControllerProvider(videoUrl));
  if (isPaused) {
    if (controller.value.isPlaying) {
      controller.pause();
    }
  } else {
    if (!controller.value.isPlaying) {
      controller.play();
    }
  }
}
