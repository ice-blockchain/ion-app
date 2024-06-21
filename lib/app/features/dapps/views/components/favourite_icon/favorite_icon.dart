import 'package:flutter/material.dart';
import 'package:ice/app/components/button/button.dart';
import 'package:ice/app/constants/ui_size.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/generated/assets.gen.dart';

final double iconSideDimension = 40.0.s;

class FavouriteIcon extends StatelessWidget {
  const FavouriteIcon({
    super.key,
    this.isFavourite = false,
    this.onTap,
    this.tintColor = Colors.black,
    this.borderRadius,
    this.size,
  });

  final bool isFavourite;
  final VoidCallback? onTap;
  final Color? tintColor;
  final double? borderRadius;
  final double? size;

  @override
  Widget build(BuildContext context) {
    final iconPath = isFavourite
        ? Assets.images.icons.iconBookmarksOn.path
        : Assets.images.icons.iconBookmarks.path;

    return Button.icon(
      onPressed: () {
        onTap?.call();
      },
      icon: Image.asset(
        iconPath,
        width: UiSize.xLarge,
        color: isFavourite ? null : tintColor,
      ),
      type: ButtonType.outlined,
      size: size ?? iconSideDimension,
      borderRadius: BorderRadius.circular(borderRadius ?? UiSize.large),
    );
  }
}
