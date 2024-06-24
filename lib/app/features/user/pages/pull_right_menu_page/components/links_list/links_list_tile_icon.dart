import 'package:flutter/material.dart';
import 'package:ice/app/constants/ui_size.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/extensions/theme_data.dart';

class LinksListTileIcon extends StatelessWidget {
  const LinksListTileIcon({
    required this.iconAssetName,
    required this.iconTintColor,
    super.key,
  });

  final String iconAssetName;
  final Color iconTintColor;

  double get containerSize => 36.0.s;

  double get iconSize => 20.0.s;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: containerSize,
      height: containerSize,
      decoration: BoxDecoration(
        color: context.theme.appColors.secondaryBackground,
        border: Border.all(
          color: context.theme.appColors.onTerararyFill,
        ),
        borderRadius: BorderRadius.circular(UiSize.small),
      ),
      child: ImageIcon(
        AssetImage(iconAssetName),
        size: iconSize,
        color: iconTintColor,
      ),
    );
  }
}
