// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ion/app/components/inputs/text_input/components/text_input_icons.dart';
import 'package:ion/app/components/inputs/text_input/text_input.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/utils/password.dart';
import 'package:ion/generated/assets.gen.dart';

class PasswordInput extends HookWidget {
  const PasswordInput({
    required this.controller,
    this.isConfirmation = false,
    this.errorText,
    super.key,
  });

  final TextEditingController controller;
  final bool isConfirmation;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    final isPasswordVisible = useState(false);

    return TextInput(
      prefixIcon: TextInputIcons(
        hasRightDivider: true,
        icons: [Assets.svg.iconPass.icon()],
      ),
      suffixIcon: TextInputIcons(
        icons: [
          SizedBox.square(
            dimension: 40.0.s,
            child: IconButton(
              icon: isPasswordVisible.value
                  ? Assets.svg.iconBlockEyeOff.icon(color: context.theme.appColors.primaryAccent)
                  : Assets.svg.iconBlockEyeOn.icon(color: context.theme.appColors.primaryAccent),
              onPressed: () {
                isPasswordVisible.value = !isPasswordVisible.value;
              },
            ),
          ),
        ],
      ),
      labelText:
          isConfirmation ? context.i18n.common_confirm_password : context.i18n.common_password,
      controller: controller,
      validator: (String? value) =>
          getPasswordStrengthValidationError(password: value, context: context),
      obscureText: isPasswordVisible.value == false,
      textInputAction: TextInputAction.done,
      scrollPadding: EdgeInsets.only(bottom: 200.0.s),
      errorText: errorText,
    );
  }
}
