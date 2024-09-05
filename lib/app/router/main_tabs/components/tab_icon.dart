import 'package:flutter/material.dart';
import 'package:ice/app/extensions/extensions.dart';

class TabIcon extends StatelessWidget {
  const TabIcon({
    required this.icon,
    required this.isSelected,
    super.key,
  });

  final String icon;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return icon.icon(
      size: 24.0.s,
      color: isSelected
          ? context.theme.appColors.primaryAccent
          : context.theme.appColors.tertararyText,
    );
  }
}
