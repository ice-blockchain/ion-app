// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/auth/views/components/user_data_inputs/general_user_data_input.dart';
import 'package:ion/app/utils/validators.dart';
import 'package:ion/generated/assets.gen.dart';

class LocationInput extends StatelessWidget {
  const LocationInput({
    super.key,
    this.controller,
    this.onChanged,
    this.initialValue,
  });

  final TextEditingController? controller;

  final ValueChanged<String>? onChanged;

  final String? initialValue;

  @override
  Widget build(BuildContext context) {
    const maxLength = 30;

    return GeneralUserDataInput(
      controller: controller,
      onChanged: onChanged,
      prefixIconAssetName: Assets.svg.iconProfileLocation,
      validator: (value) {
        if (Validators.isInvalidLength(value, maxLength: maxLength)) {
          return context.i18n.error_input_length_max(maxLength);
        }
        return null;
      },
      labelText: context.i18n.profile_location,
      initialValue: initialValue,
    );
  }
}
