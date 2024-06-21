import 'package:flutter/material.dart';
import 'package:ice/app/constants/ui_size.dart';
import 'package:ice/app/extensions/asset_gen_image.dart';
import 'package:ice/generated/assets.gen.dart';

class SectionHeaderButton extends StatelessWidget {
  const SectionHeaderButton(
    this.onPress, {
    super.key,
  });

  final VoidCallback onPress;

  static double get hitSlop => UiSize.smallMedium;
  static double get iconSize => UiSize.xLarge;
  static double get totalSize => iconSize + hitSlop * 2;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: totalSize,
      height: totalSize,
      child: IconButton(
        padding: EdgeInsets.zero,
        onPressed: onPress,
        icon: Assets.images.icons.iconButtonNext.icon(
          size: iconSize,
        ),
      ),
    );
  }
}
