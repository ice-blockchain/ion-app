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
  });

  final bool isFavourite;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final String iconPath = isFavourite
        ? Assets.images.icons.iconBookmarksOn.path
        : Assets.images.icons.iconBookmarks.path;

    final Color iconBackgroundColor =
        backgroundColor ?? context.theme.appColors.tertararyBackground;
    return Container(
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
    );
  }
}
