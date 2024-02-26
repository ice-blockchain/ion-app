import 'package:flutter/material.dart';
import 'package:ice/app/components/button/button.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/extensions/theme_data.dart';

class FeedNavigationButton extends StatelessWidget {
  const FeedNavigationButton({
    required this.iconPath,
    required this.onPressed,
  });

  final String iconPath;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Button.icon(
      type: ButtonType.menuInactive,
      size: 40.0.s,
      onPressed: onPressed,
      icon: ButtonIcon(
        iconPath,
        color: context.theme.appColors.primaryText,
      ),
    );
  }
}
