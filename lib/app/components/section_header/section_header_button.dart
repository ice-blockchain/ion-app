// SPDX-License-Identifier: ice License 1.0

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:ion/app/extensions/asset_gen_image.dart';
import 'package:ion/app/extensions/num.dart';
import 'package:ion/generated/assets.gen.dart';

class SectionHeaderButton extends StatelessWidget {
  const SectionHeaderButton(
    this.onPress, {
    super.key,
  });

  final VoidCallback onPress;

  static double get hitSlop => 10.0.s;

  static double get iconSize => 24.0.s;

  static double get totalSize => iconSize + hitSlop * 2;

  @override
  Widget build(BuildContext context) {
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
            size: iconSize,
          ),
        ),
      ),
    );
  }
}
