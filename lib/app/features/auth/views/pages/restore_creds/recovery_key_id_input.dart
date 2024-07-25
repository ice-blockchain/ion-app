import 'package:flutter/material.dart';
import 'package:ice/app/components/inputs/text_input/components/text_input_icons.dart';
import 'package:ice/app/components/inputs/text_input/text_input.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/utils/validators.dart';
import 'package:ice/generated/assets.gen.dart';

class RecoveryKeyIdInput extends StatelessWidget {
  const RecoveryKeyIdInput({required this.controller, super.key});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextInput(
      prefixIcon: TextInputIcons(
        hasRightDivider: true,
        icons: [Assets.images.icons.iconChannelPrivate.icon()],
      ),
      labelText: context.i18n.restore_identity_creds_recovery_key,
      controller: controller,
      validator: (String? value) {
        if (Validators.isEmpty(value)) return '';
        return null;
      },
      textInputAction: TextInputAction.done,
      scrollPadding: EdgeInsets.only(bottom: 200.0.s),
    );
  }
}
