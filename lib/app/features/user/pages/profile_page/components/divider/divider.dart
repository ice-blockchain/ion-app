// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/generated/assets.gen.dart';

class ProfileDivider extends StatelessWidget {
  const ProfileDivider({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final imageWidth = MediaQuery.of(context).size.width - ScreenSideOffset.defaultSmallMargin * 2;

    return Container(
      height: 32.0.s,
      alignment: Alignment.center,
      child: Assets.images.bg.divider.icon(size: imageWidth, fit: BoxFit.fitWidth),
    );
  }
}
