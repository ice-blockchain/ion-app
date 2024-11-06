// SPDX-License-Identifier: ice License 1.0

part of '../video_message.dart';

class _VideoPlayerView extends StatelessWidget {
  const _VideoPlayerView({
    required this.controller,
    required this.isMuted,
    required this.onMuteToggle,
  });

  final VideoPlayerController controller;
  final bool isMuted;
  final VoidCallback onMuteToggle;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12.0.s),
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
                _MuteButton(isMuted: isMuted, onToggle: onMuteToggle),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
