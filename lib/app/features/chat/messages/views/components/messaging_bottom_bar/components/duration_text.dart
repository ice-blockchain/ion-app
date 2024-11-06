// SPDX-License-Identifier: ice License 1.0

part of '../messaging_bottom_bar_recording.dart';

class DurationText extends StatelessWidget {
  const DurationText({
    required this.duration,
    super.key,
  });

  final String duration;

  @override
  Widget build(BuildContext context) {
    return Text(
      duration,
      style: context.theme.appTextThemes.body2.copyWith(
        color: context.theme.appColors.primaryText,
      ),
    );
  }
}
