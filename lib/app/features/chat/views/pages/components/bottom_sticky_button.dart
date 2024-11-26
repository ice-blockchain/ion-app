// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/components/button/button.dart';
import 'package:ion/app/extensions/extensions.dart';

class BottomStickyButton extends StatelessWidget {
  const BottomStickyButton({
    required this.label,
    required this.iconAsset,
    required this.onPressed,
    this.disabled = false,
    super.key,
  });

  final String label;
  final String iconAsset;
  final bool disabled;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: 16.0.s,
          horizontal: 44.0.s,
        ),
        child: Button(
          type: disabled ? ButtonType.disabled : ButtonType.primary,
          mainAxisSize: MainAxisSize.max,
          minimumSize: Size(56.0.s, 56.0.s),
          leadingIcon: iconAsset.icon(
            color: context.theme.appColors.onPrimaryAccent,
          ),
          label: Text(
            label,
          ),
          onPressed: onPressed,
        ),
      ),
    );
  }
}
