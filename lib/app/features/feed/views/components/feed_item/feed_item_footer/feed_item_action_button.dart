// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/extensions/build_context.dart';
import 'package:ion/app/extensions/num.dart';
import 'package:ion/app/extensions/theme_data.dart';

class FeedItemActionButton extends StatelessWidget {
  const FeedItemActionButton({
    required this.icon,
    required this.textColor,
    this.activeIcon,
    this.activeTextColor,
    this.isActive = false,
    this.value,
    super.key,
  });

  final Widget icon;
  final Color textColor;
  final Widget? activeIcon;
  final Color? activeTextColor;
  final bool isActive;
  final String? value;

  @override
  Widget build(BuildContext context) {
    final effectiveIcon = isActive ? activeIcon : icon;
    final effectiveTextColor = isActive ? activeTextColor : textColor;

    return Row(
      children: [
        if (effectiveIcon != null) effectiveIcon,
        if (value != null)
          Padding(
            padding: EdgeInsets.only(left: 4.0.s),
            child: Text(
              value!,
              style: context.theme.appTextThemes.caption2.copyWith(
                color: effectiveTextColor,
              ),
            ),
          ),
      ],
    );
  }
}
