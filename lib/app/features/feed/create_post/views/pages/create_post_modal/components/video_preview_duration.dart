// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/utils/date.dart';

class VideoPreviewDuration extends StatelessWidget {
  const VideoPreviewDuration({
    required this.duration,
    super.key,
  });

  final int duration;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 17.0.s,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: context.theme.appColors.backgroundSheet,
          borderRadius: BorderRadius.circular(6.0.s),
        ),
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 4.0.s,
            ),
            child: Text(
              formatDuration(Duration(seconds: duration)),
              style: context.theme.appTextThemes.caption.copyWith(
                color: context.theme.appColors.secondaryBackground,
                fontSize: 12.0.s,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
