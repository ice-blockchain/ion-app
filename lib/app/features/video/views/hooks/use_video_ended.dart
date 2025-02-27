// SPDX-License-Identifier: ice License 1.0

import 'package:cached_video_player_plus/cached_video_player_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

void useVideoEnded({
  required CachedVideoPlayerPlusController playerController,
  VoidCallback? onVideoEnded,
}) {
  final hasVideoEnded = useState(false);

  useEffect(
    () {
      void listener() {
        final duration = playerController.value.duration;
        final position = playerController.value.position;

        final isVideoEnded = position >= duration - const Duration(milliseconds: 500);
        if (isVideoEnded && !hasVideoEnded.value) {
          hasVideoEnded.value = true;
          onVideoEnded?.call();
        } else if (!isVideoEnded && hasVideoEnded.value) {
          hasVideoEnded.value = false;
        }
      }

      playerController.addListener(listener);
      return () => playerController.removeListener(listener);
    },
    [playerController],
  );
}
