import 'package:flutter/material.dart';
import 'package:ice/app/components/button/button.dart';
import 'package:ice/app/extensions/num.dart';

class SocialButton extends StatelessWidget {
  const SocialButton({
    super.key,
    required this.icon,
    required this.onPressed,
  });

  static double get width => 60.0.s;
  static double get height => 56.0.s;

  final Widget icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Button.icon(
      type: ButtonType.outlined,
      icon: icon,
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        fixedSize: Size(width, height),
      ),
    );
  }
}
