// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:video_player/video_player.dart';

class VideoProgressBar extends StatelessWidget {
  const VideoProgressBar({
    required this.controller,
    super.key,
  });

  final VideoPlayerController controller;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<VideoPlayerValue>(
      valueListenable: controller,
      builder: (context, value, child) {
        final position = value.position;
        final duration = value.duration;

        if (duration.inMilliseconds == 0) return const SizedBox();

        final progressValue = position.inMilliseconds / duration.inMilliseconds;

        return SizedBox(
          height: 4.0.s,
          child: LinearProgressIndicator(
            value: progressValue.clamp(0.0, 1.0),
            backgroundColor: context.theme.appColors.onPrimaryAccent.withValues(alpha: 0.6),
            valueColor: AlwaysStoppedAnimation<Color>(
              context.theme.appColors.onPrimaryAccent.withValues(alpha: 0.8),
            ),
            borderRadius: BorderRadius.circular(2),
          ),
        );
      },
    );
  }
}
