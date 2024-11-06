// SPDX-License-Identifier: ice License 1.0

part of '../video_message.dart';

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
