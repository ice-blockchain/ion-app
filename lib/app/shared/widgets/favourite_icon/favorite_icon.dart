import 'package:flutter/material.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/generated/assets.gen.dart';

const double iconSideDimension = 36.0;

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
        ? Assets.images.bookmarksOn.path
        : Assets.images.bookmarks.path;

    final Color iconBackgroundColor =
        backgroundColor ?? context.theme.appColors.tertararyBackground;
    return Container(
      width: iconSideDimension,
      height: iconSideDimension,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
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
            width: 24,
          ),
        ],
      ),
    );
  }
}
