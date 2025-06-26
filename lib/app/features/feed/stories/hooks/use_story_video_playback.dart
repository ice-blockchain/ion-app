// SPDX-License-Identifier: ice License 1.0

import 'package:cached_video_player_plus/cached_video_player_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/feed/stories/providers/story_pause_provider.r.dart';
import 'package:ion/app/features/feed/stories/providers/story_viewing_provider.r.dart';

void _post(VoidCallback action) => WidgetsBinding.instance.addPostFrameCallback((_) => action());

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

  final hasStarted = useRef(false);
  final completedSent = useRef(false);

  useEffect(
    () {
      if (!isCurrent) completedSent.value = false;
      return null;
    },
    [isCurrent],
  );

  useEffect(
    () {
      if (isCurrent) {
        if (paused) {
          _post(controller.pause);
        } else if (!controller.value.isPlaying) {
          if (!hasStarted.value) {
            _post(() async {
              await controller.seekTo(Duration.zero);
              await controller.play();
            });
            hasStarted.value = true;
          } else {
            _post(controller.play);
          }
        }
      } else {
        _post(controller.pause);
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
        final finished = v.position >= v.duration;

        if (isCurrent && finished && !completedSent.value) {
          completedSent.value = true;
          onCompleted();
        }
      }

      controller.addListener(listener);
      return () => controller.removeListener(listener);
    },
    [controller, isCurrent, onCompleted],
  );
}
