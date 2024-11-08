// SPDX-License-Identifier: ice License 1.0

part of '../video_message.dart';

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
