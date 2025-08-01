// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ion/app/components/button/button.dart';
import 'package:ion/app/extensions/build_context.dart';
import 'package:ion/app/extensions/num.dart';
import 'package:ion/app/extensions/theme_data.dart';
import 'package:ion/generated/assets.gen.dart';

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
      backgroundColor: context.theme.appColors.tertiaryBackground,
      borderColor: context.theme.appColors.onTertiaryFill,
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
