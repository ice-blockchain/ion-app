// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/extensions/extensions.dart';

class VideoPreviewEditCover extends StatelessWidget {
  const VideoPreviewEditCover({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 27.0.s,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: context.theme.appColors.backgroundSheet,
          borderRadius: BorderRadius.circular(16.0.s),
        ),
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 8.0.s,
            ),
            child: Text(
              context.i18n.create_video_edit_cover,
              style: context.theme.appTextThemes.body2.copyWith(
                color: context.theme.appColors.secondaryBackground,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
