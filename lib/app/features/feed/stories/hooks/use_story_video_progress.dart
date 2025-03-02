// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/animation.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/core/providers/video_player_provider.c.dart';
import 'package:video_player/video_player.dart';

VideoPlayerController? useVideoStoryProgress({
  required WidgetRef ref,
  required bool isVideo,
  required String storyId,
  required String videoUrl,
  required bool isCurrent,
  required bool isPaused,
  required VoidCallback onCompleted,
}) {
  final videoController = isVideo ? ref.watch(videoControllerProvider(videoUrl)) : null;

  final wasCurrentRef = useRef<bool>(false);

  useEffect(() {
    if (!isVideo || videoController == null) return null;

    final initialized = videoController.value.isInitialized;
    if (!initialized) return null;

    final justBecameCurrent = isCurrent && !wasCurrentRef.value;
    final becameInactive = !isCurrent && wasCurrentRef.value;

    wasCurrentRef.value = isCurrent;

    if (justBecameCurrent) {
      videoController.seekTo(Duration.zero);
      if (!isPaused) {
        videoController.play();
      }
    } else if (becameInactive) {
      videoController.pause();
    } else if (isCurrent) {
      if (isPaused && videoController.value.isPlaying) {
        videoController.pause();
      } else if (!isPaused && !videoController.value.isPlaying) {
        videoController.play();
      }
    }
    return null;
  }, [
    isVideo,
    videoController?.value.isInitialized,
    isCurrent,
    isPaused,
  ]);

  useEffect(
    () {
      if (!isVideo || videoController == null) return null;

      void listener() {
        final value = videoController.value;
        if (value.isInitialized && value.position >= value.duration && isCurrent) {
          onCompleted();
        }
      }

      videoController.addListener(listener);
      return () => videoController.removeListener(listener);
    },
    [isVideo, videoController, isCurrent, onCompleted],
  );

  return videoController;
}
