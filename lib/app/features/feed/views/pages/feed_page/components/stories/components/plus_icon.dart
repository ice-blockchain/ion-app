// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ice/app/extensions/asset_gen_image.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/generated/assets.gen.dart';

class PlusIcon extends StatelessWidget {
  PlusIcon({
    super.key,
    double? size,
  }) : size = size ?? 18.0.s;

  final double size;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            border: Border.all(
              width: 1.25.s,
              color: context.theme.appColors.secondaryBackground,
            ),
            color: context.theme.appColors.primaryAccent,
            shape: BoxShape.circle,
          ),
        ),
        Assets.svg.iconPlusCreatechannel.icon(
          size: size,
          color: context.theme.appColors.secondaryBackground,
        ),
      ],
    );
  }
}
