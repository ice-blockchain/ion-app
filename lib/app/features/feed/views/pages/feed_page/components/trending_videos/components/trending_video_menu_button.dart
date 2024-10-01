// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ice/app/extensions/asset_gen_image.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/generated/assets.gen.dart';

class TrendingVideoMenuButton extends StatelessWidget {
  const TrendingVideoMenuButton({
    required this.onPressed,
    super.key,
  });

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 40.0.s,
      child: IconButton(
        onPressed: onPressed,
        icon: Assets.svg.iconMorePopup.icon(
          size: 16.0.s,
          color: context.theme.appColors.secondaryBackground,
        ),
      ),
    );
  }
}
