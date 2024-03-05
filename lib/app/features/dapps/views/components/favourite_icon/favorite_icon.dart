import 'package:flutter/material.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/generated/assets.gen.dart';

final double iconSideDimension = 36.0.s;

class FavouriteIcon extends StatelessWidget {
  const FavouriteIcon({
    super.key,
    this.isFavourite = false,
    this.backgroundColor,
    this.onTap,
  });

  final bool isFavourite;
  final Color? backgroundColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final String iconPath = isFavourite
        ? Assets.images.icons.iconBookmarksOn.path
        : Assets.images.icons.iconBookmarks.path;

    final Color iconBackgroundColor =
        backgroundColor ?? context.theme.appColors.tertararyBackground;
    return InkWell(
      onTap: onTap,
      child: Container(
        width: iconSideDimension,
        height: iconSideDimension,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0.s),
          color: iconBackgroundColor,
          border: Border.all(
            color: context.theme.appColors.onTerararyFill,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              iconPath,
              width: 24.0.s,
            ),
          ],
        ),
      ),
    );
  }
}
