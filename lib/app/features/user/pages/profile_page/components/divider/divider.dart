// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/generated/assets.gen.dart';

class ProfileDivider extends StatelessWidget {
  const ProfileDivider({
    required this.height,
    super.key,
  });

  final double height;

  @override
  Widget build(BuildContext context) {
    final imageWidth = MediaQuery.of(context).size.width - ScreenSideOffset.defaultSmallMargin * 2;

    return Container(
      height: height,
      alignment: Alignment.center,
      child: Assets.images.bg.divider.icon(size: imageWidth, fit: BoxFit.fitWidth),
    );
  }
}
