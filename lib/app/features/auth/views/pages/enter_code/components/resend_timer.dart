import 'package:flutter/material.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/theme_data.dart';

class ResendTimer extends StatelessWidget {
  const ResendTimer({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          context.i18n.enter_code_available_in,
          style: context.theme.appTextThemes.subtitle2.copyWith(
            color: context.theme.appColors.secondaryText,
          ),
        ),
        Text(
          ' 3.0.s', // TODO: Add countdown timer
          style: context.theme.appTextThemes.subtitle2.copyWith(
            color: context.theme.appColors.primaryAccent,
          ),
        ),
      ],
    );
  }
}
