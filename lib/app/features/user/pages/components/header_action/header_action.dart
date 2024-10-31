// SPDX-License-Identifier: ice License 1.0

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:ion/app/components/button/button.dart';
import 'package:ion/app/extensions/extensions.dart';

class HeaderAction extends StatelessWidget {
  const HeaderAction({
    required this.onPressed,
    required this.assetName,
    this.disabled = false,
    this.opacity = 1,
    super.key,
  });

  final String assetName;
  final VoidCallback onPressed;
  final bool disabled;
  final double opacity;

  static double get buttonSize => 40.0.s;

  double get iconSize => 24.0.s;

  @override
  Widget build(BuildContext context) {
    final interpolatedButtonSize = lerpDouble(buttonSize, iconSize, opacity)!;
    final interpolatedBackgroundColor = Color.lerp(
      context.theme.appColors.tertararyBackground,
      context.theme.appColors.secondaryBackground,
      opacity,
    )!;
    final interpolatedBorderColor = Color.lerp(
      context.theme.appColors.onTerararyFill,
      context.theme.appColors.secondaryBackground,
      opacity,
    )!;

    return Button.icon(
      disabled: disabled,
      size: interpolatedButtonSize,
      borderColor: interpolatedBorderColor,
      backgroundColor: interpolatedBackgroundColor,
      tintColor: context.theme.appColors.primaryText,
      icon: assetName.icon(size: iconSize),
      onPressed: onPressed,
    );
  }
}
