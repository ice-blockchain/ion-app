// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/auth/views/components/user_data_inputs/general_user_data_input.dart';
import 'package:ion/app/utils/validators.dart';
import 'package:ion/generated/assets.gen.dart';

class WebsiteInput extends StatelessWidget {
  const WebsiteInput({
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
    const maxLength = 100;

    return GeneralUserDataInput(
      controller: controller,
      onChanged: onChanged,
      prefix: Text(
        'https://',
        style: context.theme.appTextThemes.body.copyWith(
          color: context.theme.appColors.tertararyText,
        ),
      ),
      prefixIconAssetName: Assets.svg.iconArticleLink,
      labelText: context.i18n.profile_website,
      initialValue: initialValue,
      validator: (String? value) {
        if (Validators.isEmpty(value)) return null;
        if (Validators.isInvalidUrl(value)) {
          return context.i18n.error_website_invalid;
        }
        if (Validators.isInvalidLength(value, maxLength: maxLength)) {
          return context.i18n.error_input_length_max(maxLength);
        }
        return null;
      },
    );
  }
}
