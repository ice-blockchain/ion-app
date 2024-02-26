import 'package:flutter/material.dart';
import 'package:ice/app/extensions/asset_gen_image.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/generated/assets.gen.dart';

class ForwardButton extends StatelessWidget {
  const ForwardButton();

  static double get hitSlop => 10.0.s;
  static double get iconSize => 24.0.s;
  static double get totalSize => iconSize + hitSlop * 2;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: totalSize,
      height: totalSize,
      child: RotatedBox(
        quarterTurns: 2,
        child: IconButton(
          padding: EdgeInsets.zero,
          onPressed: () {},
          icon: Assets.images.icons.iconBackArrow.icon(
            size: iconSize,
          ),
        ),
      ),
    );
  }
}
