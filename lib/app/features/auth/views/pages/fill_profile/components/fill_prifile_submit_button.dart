// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ice/app/components/button/button.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/generated/assets.gen.dart';

class FillProfileSubmitButton extends StatelessWidget {
  const FillProfileSubmitButton({required this.onPressed, super.key});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Button(
      trailingIcon: Assets.svg.iconProfileSave.icon(
        color: context.theme.appColors.onPrimaryAccent,
      ),
      onPressed: onPressed,
      label: Text(context.i18n.button_save),
      mainAxisSize: MainAxisSize.max,
    );
  }
}
