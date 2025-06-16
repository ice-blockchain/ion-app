// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/constants/ui.dart';
import 'package:ion/app/extensions/asset_gen_image.dart';
import 'package:ion/app/extensions/num.dart';
import 'package:ion/app/services/keyboard/keyboard.dart';
import 'package:ion/generated/assets.gen.dart';

class NavigationBackButton extends StatelessWidget {
  const NavigationBackButton(
    this.onPress, {
    super.key,
    this.hideKeyboardOnBack = false,
    this.icon,
  });

  final VoidCallback onPress;

  final bool hideKeyboardOnBack;

  final Widget? icon;

  static double get iconSize => 24.0.s;

  static double get totalSize => iconSize + UiConstants.hitSlop * 2;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: totalSize,
      height: totalSize,
      child: IconButton(
        padding: EdgeInsets.zero,
        onPressed: () => hideKeyboardOnBack ? hideKeyboard(context, callback: onPress) : onPress(),
        icon: icon ??
            Assets.svgIconBackArrow.icon(
              size: iconSize,
              flipForRtl: true,
            ),
      ),
    );
  }
}
