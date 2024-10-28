// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ion/app/constants/ui.dart';
import 'package:ion/app/extensions/num.dart';
import 'package:ion/app/hooks/use_hide_keyboard_and_call_once.dart';
import 'package:ion/generated/assets.gen.dart';

class NavigationBackButton extends HookWidget {
  const NavigationBackButton(
    this.onPress, {
    super.key,
    this.hideKeyboardOnBack = false,
  });

  final VoidCallback onPress;

  final bool hideKeyboardOnBack;

  static double get iconSize => 24.0.s;

  static double get totalSize => iconSize + UiConstants.hitSlop * 2;

  @override
  Widget build(BuildContext context) {
    final hideKeyboardAndCallOnce = useHideKeyboardAndCallOnce();
    return SizedBox(
      width: totalSize,
      height: totalSize,
      child: IconButton(
        padding: EdgeInsets.zero,
        onPressed: () =>
            hideKeyboardOnBack ? hideKeyboardAndCallOnce(callback: onPress) : onPress(),
        icon: Assets.svg.iconBackArrow.icon(
          size: iconSize,
        ),
      ),
    );
  }
}
