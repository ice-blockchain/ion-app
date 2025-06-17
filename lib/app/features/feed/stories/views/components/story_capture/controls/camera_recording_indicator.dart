// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/utils/date.dart';
import 'package:ion/generated/assets.gen.dart';

class CameraRecordingIndicator extends StatelessWidget {
  const CameraRecordingIndicator({
    required this.recordingDuration,
    super.key,
  });

  final Duration recordingDuration;

  @override
  Widget build(BuildContext context) {
    return PositionedDirectional(
      top: 12.0.s,
      start: 0.0.s,
      end: 0.0.s,
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
              IconAsset(Assets.svgIconVideosTrading, size: 16.0),
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
