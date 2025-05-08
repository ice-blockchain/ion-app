// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ion/app/constants/ui.dart';
import 'package:ion/app/extensions/build_context.dart';
import 'package:ion/app/extensions/theme_data.dart';

class NavigationTextButton extends StatelessWidget {
  const NavigationTextButton({
    required this.label,
    super.key,
    this.onPressed,
    this.textStyle,
  });

  final String label;

  final VoidCallback? onPressed;

  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed ?? () => context.pop(),
      child: Padding(
        padding: EdgeInsets.all(UiConstants.hitSlop),
        child: Text(
          label,
          style: textStyle ??
              context.theme.appTextThemes.body.copyWith(
                color: context.theme.appColors.primaryAccent,
              ),
        ),
      ),
    );
  }
}
