// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/generated/assets.gen.dart';

class CameraPlaceholderWidget extends StatelessWidget {
  const CameraPlaceholderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return ColoredBox(
      color: theme.appColors.sheetLine,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Assets.svgIconCameraOpen.icon(
            size: 40.0.s,
            color: theme.appColors.onPrimaryAccent,
          ),
          SizedBox(height: 2.0.s),
          Text(
            context.i18n.camera,
            style: theme.appTextThemes.body.copyWith(
              color: theme.appColors.onPrimaryAccent,
            ),
          ),
        ],
      ),
    );
  }
}
