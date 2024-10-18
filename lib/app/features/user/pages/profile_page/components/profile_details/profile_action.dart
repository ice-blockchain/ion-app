// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ice/app/components/button/button.dart';
import 'package:ice/app/extensions/extensions.dart';

class ProfileAction extends StatelessWidget {
  const ProfileAction({
    required this.onPressed,
    required this.assetName,
    super.key,
  });

  final String assetName;
  final VoidCallback onPressed;

  double get buttonSize => 36.0.s;

  double get iconSize => 16.0.s;

  @override
  Widget build(BuildContext context) {
    return Button.icon(
      size: buttonSize,
      fixedSize: Size(36.0.s, 24.0.s),
      borderRadius: BorderRadius.circular(20.0.s),
      borderColor: context.theme.appColors.onTerararyFill,
      backgroundColor: context.theme.appColors.tertararyBackground,
      tintColor: context.theme.appColors.primaryText,
      icon: assetName.icon(size: iconSize, color: context.theme.appColors.primaryText),
      onPressed: onPressed,
    );
  }
}
