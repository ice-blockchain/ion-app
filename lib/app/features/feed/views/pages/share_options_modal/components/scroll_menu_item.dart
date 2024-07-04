import 'package:flutter/material.dart';
import 'package:ice/app/components/button/button.dart';
import 'package:ice/app/extensions/extensions.dart';

class ScrollMenuItem extends StatelessWidget {
  const ScrollMenuItem({
    required this.icon,
    required this.label,
    required this.onPressed,
    required this.buttonType,
    super.key,
  });

  final Widget icon;
  final String label;
  final VoidCallback onPressed;
  final ButtonType buttonType;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 72.0.s,
      child: Column(
        children: [
          Button.icon(
            type: buttonType,
            onPressed: onPressed,
            icon: icon,
          ),
          SizedBox(height: 6.0.s),
          Text(
            label,
            style: context.theme.appTextThemes.caption2,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
