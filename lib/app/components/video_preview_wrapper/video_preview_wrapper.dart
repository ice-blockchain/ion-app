// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/utils/date.dart';
import 'package:ion/generated/assets.gen.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

class VideoPreviewWrapper extends HookWidget {
  const VideoPreviewWrapper({
    required this.controller,
    super.key,
  });

  final VideoPlayerController controller;

  @override
  Widget build(BuildContext context) {
    final isMuted = useState(true);

    useEffect(
      () {
        controller.setVolume(0); // Start muted
        return controller.dispose;
      },
      [controller],
    );

    return VisibilityDetector(
      key: ValueKey(controller.dataSource),
      onVisibilityChanged: (info) {
        if (info.visibleFraction == 0) {
          controller
            ..pause()
            ..setVolume(0);
          isMuted.value = true;
        } else {
          controller.play();
        }
      },
      child: Stack(
        children: [
          AspectRatio(
            aspectRatio: controller.value.aspectRatio,
            child: VideoPlayer(controller),
          ),
          Positioned(
            bottom: 5.0.s,
            left: 5.0.s,
            right: 5.0.s,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _VideoDurationLabel(duration: controller.value.duration),
                _MuteButton(
                  isMuted: isMuted.value,
                  onToggle: () {
                    isMuted.value = !isMuted.value;
                    controller.setVolume(isMuted.value ? 0 : 1);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _VideoDurationLabel extends StatelessWidget {
  const _VideoDurationLabel({required this.duration});

  final Duration duration;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.0.s, vertical: 1.0.s),
      decoration: BoxDecoration(
        color: context.theme.appColors.backgroundSheet.withOpacity(0.7),
        borderRadius: BorderRadius.circular(6.0.s),
      ),
      child: Text(
        formatDuration(duration),
        style: context.theme.appTextThemes.caption.copyWith(
          color: context.theme.appColors.secondaryBackground,
        ),
      ),
    );
  }
}

class _MuteButton extends StatelessWidget {
  const _MuteButton({required this.isMuted, required this.onToggle});

  final bool isMuted;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onToggle,
      child: Container(
        padding: EdgeInsets.all(6.0.s),
        decoration: BoxDecoration(
          color: context.theme.appColors.backgroundSheet.withOpacity(0.7),
          borderRadius: BorderRadius.circular(12.0.s),
        ),
        child: isMuted
            ? Assets.svg.iconChannelMute.icon(
                size: 16.0.s,
                color: context.theme.appColors.onPrimaryAccent,
              )
            : Assets.svg.iconChannelUnmute.icon(
                size: 16.0.s,
                color: context.theme.appColors.onPrimaryAccent,
              ),
      ),
    );
  }
}