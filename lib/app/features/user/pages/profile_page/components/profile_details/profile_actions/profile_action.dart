// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/components/button/button.dart';
import 'package:ion/app/extensions/extensions.dart';

class ProfileAction extends StatelessWidget {
  const ProfileAction({
    required this.onPressed,
    required this.assetName,
    this.isAccent = false,
    super.key,
  });

  final String assetName;
  final VoidCallback onPressed;
  final bool isAccent;

  double get buttonSize => 36.0.s;

  double get iconSize => 16.0.s;

  @override
  Widget build(BuildContext context) {
    final colors = context.theme.appColors;

    return Button.icon(
      size: buttonSize,
      fixedSize: Size(36.0.s, 24.0.s),
      borderRadius: BorderRadius.circular(20.0.s),
      borderColor: colors.onTerararyFill,
      backgroundColor: colors.tertararyBackground,
      tintColor: colors.primaryText,
      icon: IconAssetColored(
        assetName,
        size: iconSize,
        color: isAccent ? colors.primaryAccent : colors.primaryText,
      ),
      onPressed: onPressed,
    );
  }
}
