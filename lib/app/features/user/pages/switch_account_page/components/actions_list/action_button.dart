import 'package:flutter/material.dart';
import 'package:ice/app/components/button/button.dart';
import 'package:ice/app/extensions/num.dart';

class ActionButton extends StatelessWidget {
  const ActionButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final Widget icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0.s),
      child: Button(
        leadingIcon: icon,
        onPressed: onTap,
        label: Text(label),
        mainAxisSize: MainAxisSize.max,
        type: ButtonType.secondary,
      ),
    );
  }
}
