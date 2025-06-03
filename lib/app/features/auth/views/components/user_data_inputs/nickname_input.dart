// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/auth/views/components/user_data_inputs/general_user_data_input.dart';
import 'package:ion/app/utils/validators.dart';
import 'package:ion/generated/assets.gen.dart';

const int _nicknameMaxLength = 20;

class NicknameInput extends StatelessWidget {
  const NicknameInput({
    super.key,
    this.textInputAction,
    this.onChanged,
    this.initialValue,
    this.errorText,
    this.isLive = false,
  });

  final TextInputAction? textInputAction;

  final ValueChanged<String>? onChanged;

  final String? initialValue;

  final String? errorText;

  final bool isLive;

  @override
  Widget build(BuildContext context) {
    return GeneralUserDataInput(
      onChanged: onChanged,
      prefixIconAssetName: Assets.svg.iconFieldNickname,
      labelText: context.i18n.fill_profile_input_nickname,
      textInputAction: textInputAction,
      initialValue: initialValue,
      isLive: isLive,
      showNoErrorsIndicator: isLive,
      errorText: errorText,
      validator: (String? value) {
        if (Validators.isEmpty(value)) return '';

        if (Validators.isInvalidNickname(value)) {
          return context.i18n.error_nickname_invalid;
        }

        if (Validators.isInvalidLength(value, maxLength: _nicknameMaxLength)) {
          return context.i18n.error_input_length_max(_nicknameMaxLength);
        }
        return null;
      },
    );
  }
}
