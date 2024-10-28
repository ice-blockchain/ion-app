// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/components/inputs/text_input/components/text_input_icons.dart';
import 'package:ion/app/components/inputs/text_input/text_input.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/auth/views/components/identity_key_name_input/identity_info.dart';
import 'package:ion/app/router/utils/show_simple_bottom_sheet.dart';
import 'package:ion/app/utils/validators.dart';
import 'package:ion/generated/assets.gen.dart';

class IdentityKeyNameInput extends StatelessWidget {
  const IdentityKeyNameInput({
    this.textInputAction = TextInputAction.done,
    this.controller,
    this.scrollPadding,
    this.notShowInfoIcon = false,
    this.errorText,
    super.key,
  });

  final TextEditingController? controller;

  final TextInputAction textInputAction;

  final EdgeInsets? scrollPadding;
  final bool notShowInfoIcon;

  final String? errorText;

  @override
  Widget build(BuildContext context) {
    return TextInput(
      keyboardType: TextInputType.emailAddress,
      prefixIcon: TextInputIcons(
        hasRightDivider: true,
        icons: [Assets.svg.iconIdentitykey.icon()],
      ),
      suffixIcon: notShowInfoIcon
          ? null
          : TextInputIcons(
              icons: [
                SizedBox.square(
                  dimension: 40.0.s,
                  child: IconButton(
                    icon: Assets.svg.iconBlockInformation.icon(),
                    onPressed: () {
                      showSimpleBottomSheet<void>(
                        context: context,
                        child: const IdentityInfo(),
                        useRootNavigator: false,
                      );
                    },
                  ),
                ),
              ],
            ),
      labelText: context.i18n.common_identity_key_name,
      controller: controller,
      validator: (String? value) {
        if (Validators.isEmpty(value)) return '';
        return null;
      },
      textInputAction: textInputAction,
      scrollPadding: scrollPadding ?? EdgeInsets.only(bottom: 100.0.s),
      errorText: errorText,
    );
  }
}
