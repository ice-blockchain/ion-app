// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/components/inputs/text_input/components/text_input_icons.dart';
import 'package:ion/app/components/inputs/text_input/text_input.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/utils/validators.dart';
import 'package:ion/generated/assets.gen.dart';

class NicknameInput extends StatelessWidget {
  const NicknameInput({required this.controller, super.key});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextInput(
      prefixIcon: TextInputIcons(
        hasRightDivider: true,
        icons: [Assets.svg.iconFieldNickname.icon(color: context.theme.appColors.secondaryText)],
      ),
      labelText: context.i18n.fill_profile_input_nickname,
      controller: controller,
      validator: (String? value) {
        if (Validators.isEmpty(value)) return '';
        if (Validators.isInvalidName(value)) {
          return context.i18n.error_nickname_invalid;
        }
        return null;
      },
      textInputAction: TextInputAction.next,
      scrollPadding: EdgeInsets.all(120.0.s),
    );
  }
}
