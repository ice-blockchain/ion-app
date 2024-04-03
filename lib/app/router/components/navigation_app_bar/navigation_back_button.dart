import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ice/app/constants/ui.dart';
import 'package:ice/app/extensions/asset_gen_image.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/hooks/use_hide_keyboard_and_call_once.dart';
import 'package:ice/generated/assets.gen.dart';

class NavigationBackButton extends HookWidget {
  const NavigationBackButton(
    this.onPress, {
    this.hideKeyboardOnBack = false,
  });

  final VoidCallback onPress;

  final bool hideKeyboardOnBack;

  static double get iconSize => 24.0.s;

  static double get totalSize => iconSize + UiConstants.hitSlop * 2;

  @override
  Widget build(BuildContext context) {
    final void Function({VoidCallback? callback}) hideKeyboardAndCallOnce =
        useHideKeyboardAndCallOnce();
    return SizedBox(
      width: totalSize,
      height: totalSize,
      child: IconButton(
        padding: EdgeInsets.zero,
        onPressed: () => hideKeyboardOnBack
            ? hideKeyboardAndCallOnce(callback: onPress)
            : onPress(),
        icon: Assets.images.icons.iconBackArrow.icon(
          size: iconSize,
        ),
      ),
    );
  }
}
