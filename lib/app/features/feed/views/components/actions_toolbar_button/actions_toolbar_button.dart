import 'package:flutter/material.dart';
import 'package:ice/app/extensions/asset_gen_image.dart';
import 'package:ice/app/extensions/num.dart';

class ActionsToolbarButton extends StatelessWidget {
  const ActionsToolbarButton({
    required this.icon,
    required this.onPressed,
    this.iconSelected,
    this.selected = false,
  });

  final VoidCallback onPressed;
  final String icon;
  final String? iconSelected;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onPressed,
        child: (selected && iconSelected != null ? iconSelected! : icon).icon(size: 24.0.s));
  }
}
