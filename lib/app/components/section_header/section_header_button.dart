// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
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
        icon: Assets.svg.iconButtonNext.icon(
          size: iconSize,
        ),
      ),
    );
  }
}
