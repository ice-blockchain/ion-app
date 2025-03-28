// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/extensions/build_context.dart';
import 'package:ion/app/extensions/num.dart';
import 'package:ion/app/extensions/theme_data.dart';

enum TextActionButtonState {
  idle,
  active,
  disabled,
}

class TextActionButton extends StatelessWidget {
  const TextActionButton({
    required this.icon,
    required this.textColor,
    this.activeIcon,
    this.activeTextColor,
    this.disabledIcon,
    this.disabledTextColor,
    this.state = TextActionButtonState.idle,
    this.value,
    super.key,
  });

  final Widget icon;
  final Color textColor;
  final Widget? activeIcon;
  final Color? activeTextColor;
  final Widget? disabledIcon;
  final Color? disabledTextColor;
  final TextActionButtonState state;
  final String? value;

  @override
  Widget build(BuildContext context) {
    final effectiveIcon = _getIcon();
    final effectiveTextColor = _getColor();

    return Row(
      children: [
        if (effectiveIcon != null) effectiveIcon,
        if (value != null)
          Padding(
            padding: EdgeInsetsDirectional.only(start: 4.0.s),
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

  Widget? _getIcon() => switch (state) {
        TextActionButtonState.idle => icon,
        TextActionButtonState.active => activeIcon ?? icon,
        TextActionButtonState.disabled => disabledIcon ?? icon,
      };

  Color _getColor() => switch (state) {
        TextActionButtonState.idle => textColor,
        TextActionButtonState.active => activeTextColor ?? textColor,
        TextActionButtonState.disabled => disabledTextColor ?? textColor,
      };
}
