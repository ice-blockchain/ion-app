// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/components/button/button.dart';
import 'package:ion/app/extensions/num.dart';

class NavigationButton extends StatelessWidget {
  const NavigationButton({
    required this.icon,
    required this.onPressed,
    super.key,
    this.size,
  });

  final Widget icon;
  final VoidCallback onPressed;
  final double? size;

  static double get defaultSize => 40.0.s;

  @override
  Widget build(BuildContext context) {
    return Button.icon(
      type: ButtonType.menuInactive,
      size: size ?? defaultSize,
      onPressed: onPressed,
      icon: icon,
    );
  }
}
