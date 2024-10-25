// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/auth/views/components/user_data_inputs/general_user_data_input.dart';
import 'package:ion/app/utils/validators.dart';
import 'package:ion/generated/assets.gen.dart';

class NicknameInput extends StatelessWidget {
  const NicknameInput({required this.controller, super.key, this.textInputAction});

  final TextEditingController controller;

  final TextInputAction? textInputAction;

  @override
  Widget build(BuildContext context) {
    return GeneralUserDataInput(
      controller: controller,
      prefixIconAssetName: Assets.svg.iconFieldNickname,
      labelText: context.i18n.fill_profile_input_nickname,
      textInputAction: textInputAction,
      validator: (String? value) {
        if (Validators.isEmpty(value)) return '';
        if (Validators.isInvalidName(value)) {
          return context.i18n.error_nickname_invalid;
        }
        return null;
      },
    );
  }
}
