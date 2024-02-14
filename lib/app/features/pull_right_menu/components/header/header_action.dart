import 'package:flutter/material.dart';
import 'package:ice/app/components/button/button.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/extensions/theme_data.dart';

class HeaderAction extends StatelessWidget {
  const HeaderAction({
    super.key,
    required this.onPressed,
    required this.assetName,
  });

  final String assetName;
  final VoidCallback onPressed;

  double get buttonSize => 40.0.s;

  double get iconSize => 20.0.s;

  @override
  Widget build(BuildContext context) {
    return Button.icon(
      size: buttonSize,
      borderColor: context.theme.appColors.onTerararyFill,
      backgroundColor: context.theme.appColors.tertararyBackground,
      tintColor: context.theme.appColors.primaryText,
      icon: ImageIcon(
        AssetImage(assetName),
        size: iconSize,
      ),
      onPressed: onPressed,
    );
  }
}
