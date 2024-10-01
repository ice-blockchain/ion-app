// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ice/app/components/button/button.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/generated/assets.gen.dart';

final double iconSideDimension = 40.0.s;

class FavouriteIcon extends StatelessWidget {
  const FavouriteIcon({
    super.key,
    this.isFavourite = false,
    this.onTap,
    this.borderRadius,
    this.size,
  });

  final bool isFavourite;
  final VoidCallback? onTap;
  final double? borderRadius;
  final double? size;

  @override
  Widget build(BuildContext context) {
    final iconPath = isFavourite ? Assets.svg.iconBookmarksOn : Assets.svg.iconBookmarks;

    return Button.icon(
      onPressed: () {
        onTap?.call();
      },
      backgroundColor: context.theme.appColors.tertararyBackground,
      borderColor: context.theme.appColors.onTerararyFill,
      icon: SvgPicture.asset(
        iconPath,
        width: 24.0.s,
      ),
      type: ButtonType.outlined,
      size: size ?? iconSideDimension,
      borderRadius: BorderRadius.circular(borderRadius ?? 16.0.s),
    );
  }
}
