import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ice/app/constants/ui.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/theme_data.dart';

class NavigationTextButton extends StatelessWidget {
  const NavigationTextButton({
    super.key,
    required this.label,
    this.onPressed,
  });

  final String label;

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: Padding(
        padding: EdgeInsets.all(UiConstants.hitSlop),
        child: Text(
          label,
          style: context.theme.appTextThemes.body.copyWith(
            color: context.theme.appColors.primaryAccent,
          ),
        ),
      ),
      onPressed: onPressed ?? () => context.pop(),
    );
  }
}
