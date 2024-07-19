import 'package:flutter/material.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/generated/assets.gen.dart';

class TabIcon extends StatelessWidget {
  const TabIcon({
    required this.icon,
    required this.isSelected,
    super.key,
  });

  final AssetGenImage icon;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return icon.image(
      width: 24.0.s,
      height: 24.0.s,
      color: isSelected
          ? context.theme.appColors.primaryAccent
          : context.theme.appColors.tertararyText,
    );
  }
}
