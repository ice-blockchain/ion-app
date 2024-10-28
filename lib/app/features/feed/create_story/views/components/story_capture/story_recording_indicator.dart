// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/utils/date.dart';
import 'package:ion/generated/assets.gen.dart';

class StoryRecordingIndicator extends StatelessWidget {
  const StoryRecordingIndicator({
    required this.recordingDuration,
    super.key,
  });
  final Duration recordingDuration;

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
