import 'package:flutter/material.dart';
import 'package:ice/app/components/button/button.dart';
import 'package:ice/app/extensions/num.dart';

class FeedNavigationButton extends StatelessWidget {
  const FeedNavigationButton({
    required this.icon,
    required this.onPressed,
  });

  final Widget icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Button.icon(
      type: ButtonType.menuInactive,
      size: 40.0.s,
      onPressed: onPressed,
      icon: icon,
    );
  }
}
