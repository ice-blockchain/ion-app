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
      if (isPaused) {
        progressController.stop();

        if (storyUrl != null) {
          final controller = ref.read(videoControllerProvider(storyUrl));
          if (controller.value.isPlaying) {
            controller.pause();
          }
        }
      } else {
        progressController.forward();

        if (storyUrl != null) {
          final controller = ref.read(videoControllerProvider(storyUrl));
          if (!controller.value.isPlaying) {
            controller.play();
          }
        }
      }
      return null;
    },
    [isPaused],
  );
}
