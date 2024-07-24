import 'package:flutter/material.dart';
import 'package:ice/app/components/inputs/text_input/components/text_input_icons.dart';
import 'package:ice/app/components/inputs/text_input/text_input.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/utils/validators.dart';
import 'package:ice/generated/assets.gen.dart';

class RecoveryCodeInput extends StatelessWidget {
  const RecoveryCodeInput({required this.controller, super.key, this.onChanged});

  final TextEditingController controller;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return TextInput(
      prefixIcon: TextInputIcons(
        hasRightDivider: true,
        icons: [Assets.images.icons.iconCode4.icon()],
      ),
      labelText: context.i18n.restore_identity_creds_recovery_code,
      controller: controller,
      validator: (String? value) {
        if (Validators.isEmpty(value)) return '';
        return null;
      },
      textInputAction: TextInputAction.next,
      scrollPadding: EdgeInsets.only(bottom: 200.0.s),
      onChanged: onChanged,
    );
  }
}
