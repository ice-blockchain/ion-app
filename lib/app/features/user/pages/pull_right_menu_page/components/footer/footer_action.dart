import 'package:flutter/material.dart';
import 'package:ice/app/components/button/button.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/extensions/theme_data.dart';

class FooterAction extends StatelessWidget {
  const FooterAction({
    super.key,
    required this.onPressed,
    required this.assetName,
    required this.label,
  });

  final String label;
  final String assetName;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      label: Text(
        label,
        style: context.theme.appTextThemes.body
            .copyWith(color: context.theme.appColors.primaryText),
      ),
      icon: Padding(
        padding: EdgeInsets.only(right: 12.0.s),
        child: ButtonIcon(assetName),
      ),
      onPressed: onPressed,
    );
  }
}
