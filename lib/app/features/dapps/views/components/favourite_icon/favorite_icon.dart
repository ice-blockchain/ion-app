import 'package:flutter/material.dart';
import 'package:ice/app/components/button/button.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/generated/assets.gen.dart';

final double iconSideDimension = 40.0.s;

class FavouriteIcon extends StatelessWidget {
  const FavouriteIcon({
    super.key,
    this.isFavourite = false,
    this.onTap,
  });

  final bool isFavourite;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final String iconPath = isFavourite
        ? Assets.images.icons.iconBookmarksOn.path
        : Assets.images.icons.iconBookmarks.path;

    return Button.icon(
      onPressed: () {
        onTap?.call();
      },
      icon: Image.asset(
        iconPath,
        width: 24.0.s,
      ),
      type: ButtonType.outlined,
      size: iconSideDimension,
    );
  }
}
