// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/auth/views/components/user_data_inputs/general_user_data_input.dart';
import 'package:ion/app/utils/validators.dart';
import 'package:ion/generated/assets.gen.dart';

class BioInput extends StatelessWidget {
  const BioInput({
    this.controller,
    this.onChanged,
    this.initialValue,
    super.key,
  });

  final TextEditingController? controller;

  final ValueChanged<String>? onChanged;

  final String? initialValue;

  @override
  Widget build(BuildContext context) {
    const bioMaxLength = 140;

    return GeneralUserDataInput(
      controller: controller,
      onChanged: onChanged,
      initialValue: initialValue,
      validator: (value) {
        if (Validators.isInvalidLength(value, maxLength: bioMaxLength)) {
          return context.i18n.error_input_length_max(bioMaxLength);
        }
        return null;
      },
      prefixIconAssetName: Assets.svgIconProfileBio,
      labelText: context.i18n.profile_bio,
      textInputAction: TextInputAction.newline,
      minLines: 1,
      maxLines: 5,
    );
  }
}
