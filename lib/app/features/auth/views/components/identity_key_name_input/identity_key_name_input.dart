import 'package:flutter/material.dart';
import 'package:ice/app/components/inputs/text_input/components/text_input_icons.dart';
import 'package:ice/app/components/inputs/text_input/text_input.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/auth/views/components/identity_key_name_input/identity_info.dart';
import 'package:ice/app/router/utils/show_simple_bottom_sheet.dart';
import 'package:ice/app/utils/validators.dart';
import 'package:ice/generated/assets.gen.dart';

class IdentityKeyNameInput extends StatelessWidget {
  const IdentityKeyNameInput({
    this.textInputAction = TextInputAction.done,
    super.key,
    this.controller,
  });

  final TextEditingController? controller;

  final TextInputAction textInputAction;

  @override
  Widget build(BuildContext context) {
    return TextInput(
      prefixIcon: TextInputIcons(
        hasRightDivider: true,
        icons: [Assets.images.icons.iconIdentitykey.icon()],
      ),
      suffixIcon: TextInputIcons(
        icons: [
          IconButton(
            icon: Assets.images.icons.iconBlockInformation.icon(
              size: 20.0.s,
            ),
            onPressed: () {
              showSimpleBottomSheet<void>(
                context: context,
                child: const IdentityInfo(),
                useRootNavigator: false,
              );
            },
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
      scrollPadding: EdgeInsets.all(120.0.s),
    );
  }
}
