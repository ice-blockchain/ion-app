// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/generated/assets.gen.dart';

class RecordingIndicator extends StatelessWidget {
  const RecordingIndicator({
    required this.recordingDuration,
    super.key,
  });
  final Duration recordingDuration;

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 12.0.s,
      left: 0.0.s,
      right: 0.0.s,
      child: Center(
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 8.0.s,
            vertical: 6.0.s,
          ),
          decoration: BoxDecoration(
            color: context.theme.appColors.raspberry,
            borderRadius: BorderRadius.circular(8.0.s),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Assets.svg.iconVideosTrading.icon(size: 16.0.s),
              SizedBox(width: 6.0.s),
              Text(
                formatDuration(recordingDuration),
                style: context.theme.appTextThemes.subtitle.copyWith(
                  color: context.theme.appColors.secondaryBackground,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
