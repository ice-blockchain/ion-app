// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/extensions/extensions.dart';

class ContextMenuItem extends StatelessWidget {
  const ContextMenuItem({
    required this.label,
    required this.iconAsset,
    required this.onPressed,
    this.textColor,
    this.iconColor,
    super.key,
  });

  static double get iconSize => 20.0.s;

  final String label;
  final String iconAsset;
  final VoidCallback onPressed;
  final Color? textColor;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    final colors = context.theme.appColors;
    final textStyles = context.theme.appTextThemes;

    return GestureDetector(
      onTap: onPressed,
      child: SizedBox(
        height: 44.0.s,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0.s),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: textStyles.subtitle3.copyWith(
                  color: textColor ?? colors.primaryText,
                ),
              ),
              SizedBox(
                width: 12.0.s,
              ),
              iconAsset.icon(
                size: iconSize,
                color: iconColor ?? colors.quaternaryText,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
