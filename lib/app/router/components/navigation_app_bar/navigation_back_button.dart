import 'package:flutter/material.dart';
import 'package:ice/app/constants/ui.dart';
import 'package:ice/app/extensions/asset_gen_image.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/generated/assets.gen.dart';

class NavigationBackButton extends StatelessWidget {
  const NavigationBackButton(
    this.onPress,
  );

  final VoidCallback onPress;

  static double get iconSize => 24.0.s;

  static double get totalSize => iconSize + UiConstants.hitSlop * 2;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: totalSize,
      height: totalSize,
      child: IconButton(
        padding: EdgeInsets.zero,
        onPressed: onPress,
        icon: Assets.images.icons.iconBackArrow.icon(
          size: iconSize,
        ),
      ),
    );
  }
}
