// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/components/inputs/text_input/components/text_input_icons.dart';
import 'package:ion/app/components/inputs/text_input/text_input.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/utils/validators.dart';
import 'package:ion/generated/assets.gen.dart';

class PasswordInput extends StatelessWidget {
  const PasswordInput({
    required this.controller,
    this.isConfirmation = false,
    super.key,
  });

  final TextEditingController controller;
  final bool isConfirmation;

  @override
  Widget build(BuildContext context) {
    return TextInput(
      prefixIcon: TextInputIcons(
        hasRightDivider: true,
        icons: [Assets.svg.iconPass.icon()],
      ),
      labelText:
          isConfirmation ? context.i18n.common_confirm_password : context.i18n.common_password,
      controller: controller,
      validator: (String? value) {
        if (Validators.isEmpty(value)) return '';
        if (Validators.isInvalidLength(value, minLength: 8)) return '';
        return null;
      },
      obscureText: true,
      textInputAction: TextInputAction.done,
      scrollPadding: EdgeInsets.only(bottom: 200.0.s),
    );
  }
}
