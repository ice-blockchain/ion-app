// SPDX-License-Identifier: ice License 1.0

part of '../messaging_bottom_bar_recording.dart';

class RecordingRedIndicator extends StatelessWidget {
  const RecordingRedIndicator({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 4.0.s,
      height: 4.0.s,
      decoration: BoxDecoration(
        color: context.theme.appColors.attentionRed,
        borderRadius: BorderRadius.circular(12.0.s),
      ),
    );
  }
}
