// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ice/app/components/button/button.dart';
import 'package:ice/app/extensions/extensions.dart';

class HeaderAction extends StatelessWidget {
  const HeaderAction({
    required this.onPressed,
    required this.assetName,
    super.key,
  });

  final String assetName;
  final VoidCallback onPressed;

  double get buttonSize => 40.0.s;

  double get iconSize => 20.0.s;

  @override
  Widget build(BuildContext context) {
    return Button.icon(
      size: buttonSize,
      borderColor: context.theme.appColors.onTerararyFill,
      backgroundColor: context.theme.appColors.tertararyBackground,
      tintColor: context.theme.appColors.primaryText,
      icon: assetName.icon(size: iconSize),
      onPressed: onPressed,
    );
  }
}
