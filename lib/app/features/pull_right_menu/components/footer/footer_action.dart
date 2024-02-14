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
    return Button(
      type: ButtonType.outlined,
      borderColor: context.theme.appColors.secondaryBackground,
      label: Text(
        label,
        style: context.theme.appTextThemes.body
            .copyWith(color: context.theme.appColors.primaryText),
      ),
      leadingIcon: Padding(
        padding: EdgeInsets.only(right: 12.0.s),
        child: ButtonIcon(assetName),
      ),
      minimumSize: Size(24.0.s, 24.0.s),
      onPressed: onPressed,
      disableRipple: true,
    );
  }
}
