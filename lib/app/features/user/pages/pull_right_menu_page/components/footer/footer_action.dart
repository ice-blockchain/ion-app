import 'package:flutter/material.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/extensions/theme_data.dart';

class FooterAction extends StatelessWidget {
  const FooterAction({
    required this.onPressed,
    required this.icon,
    required this.label,
    super.key,
  });

  final String label;
  final Widget icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      style: TextButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 12.0.s, vertical: 8.0.s),
      ),
      label: Text(
        label,
        style:
            context.theme.appTextThemes.body.copyWith(color: context.theme.appColors.primaryText),
      ),
      icon: Padding(
        padding: EdgeInsets.only(right: 12.0.s),
        child: icon,
      ),
      onPressed: onPressed,
    );
  }
}
