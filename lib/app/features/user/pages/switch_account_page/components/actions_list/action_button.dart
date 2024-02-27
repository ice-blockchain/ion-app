import 'package:flutter/material.dart';
import 'package:ice/app/components/button/button.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/extensions/theme_data.dart';

class ActionButton extends StatelessWidget {
  const ActionButton({
    super.key,
    required this.iconPath,
    required this.label,
    required this.onTap,
  });

  final String iconPath;
  final String label;
  final VoidCallback onTap;

  double get iconSize => 24.0.s;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0.s),
      child: Button(
        leadingIcon: ButtonIcon(
          iconPath,
          color: context.theme.appColors.primaryAccent,
        ),
        onPressed: onTap,
        label: Text(
          label,
          style: context.theme.appTextThemes.body
              .copyWith(color: context.theme.appColors.primaryText),
        ),
        mainAxisSize: MainAxisSize.max,
        backgroundColor: context.theme.appColors.tertararyBackground,
      ),
    );
  }
}
