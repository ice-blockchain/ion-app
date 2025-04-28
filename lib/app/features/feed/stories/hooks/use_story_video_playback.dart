// SPDX-License-Identifier: ice License 1.0

import 'package:cached_video_player_plus/cached_video_player_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/feed/stories/providers/story_pause_provider.c.dart';
import 'package:ion/app/features/feed/stories/providers/story_viewing_provider.c.dart';

void useStoryVideoPlayback({
  required WidgetRef ref,
  required CachedVideoPlayerPlusController? controller,
  required String storyId,
  required String viewerPubkey,
  required VoidCallback onCompleted,
}) {
  if (controller == null || !controller.value.isInitialized) return;

  final paused = ref.watch(storyPauseControllerProvider);
  final viewing = ref.watch(storyViewingControllerProvider(viewerPubkey));
  final isCurrent = viewing.currentStory?.id == storyId;

  final hasStarted = useRef<bool>(false);

  useEffect(
    () {
      if (isCurrent) {
        if (paused) {
          controller.pause();
        } else if (!controller.value.isPlaying) {
          if (!hasStarted.value) {
            controller
              ..seekTo(Duration.zero)
              ..play();
            hasStarted.value = true;
          } else {
            controller.play();
          }
        }
      } else {
        controller.pause();
        hasStarted.value = false;
      }
      return null;
    },
    [paused, isCurrent],
  );

  useEffect(
    () {
      void listener() {
        final v = controller.value;
        if (v.position >= v.duration && isCurrent) onCompleted();
      }

      controller.addListener(listener);
      return () => controller.removeListener(listener);
    },
    [controller, isCurrent, onCompleted],
  );
}
