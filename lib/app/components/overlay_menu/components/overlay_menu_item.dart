// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/extensions/extensions.dart';

class OverlayMenuItem extends StatelessWidget {
  const OverlayMenuItem({
    required this.label,
    required this.icon,
    required this.onPressed,
    super.key,
    this.labelColor,
  });

  final String label;
  final Widget icon;
  final VoidCallback onPressed;
  final Color? labelColor;

  @override
  Widget build(BuildContext context) {
    final colors = context.theme.appColors;
    final textStyles = context.theme.appTextThemes;

    return GestureDetector(
      onTap: onPressed,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0.s, vertical: 8.0.s),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: 99.0.s,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  label,
                  style: textStyles.subtitle3.copyWith(
                    color: labelColor ?? colors.primaryText,
                  ),
                ),
              ),
              icon,
            ],
          ),
        ),
      ),
    );
  }
}