// SPDX-License-Identifier: ice License 1.0

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:ion/app/extensions/asset_gen_image.dart';
import 'package:ion/app/extensions/num.dart';
import 'package:ion/generated/assets.gen.dart';

class SectionHeaderButton extends StatelessWidget {
  const SectionHeaderButton({
    this.onPress,
    super.key,
    this.iconSize,
  });

  final VoidCallback? onPress;
  final double? iconSize;

  static double get hitSlop => 10.0.s;

  @override
  Widget build(BuildContext context) {
    final size = iconSize ?? 24.0.s;
    final totalSize = size + hitSlop * 2;

    return SizedBox(
      width: totalSize,
      height: totalSize,
      child: IconButton(
        padding: EdgeInsets.zero,
        onPressed: onPress,
        icon: Transform(
          alignment: Alignment.center,
          transform: Matrix4.rotationY(pi),
          child: Assets.svg.iconChatBack.icon(
            size: size,
            flipForRtl: true,
          ),
        ),
      ),
    );
  }
}
