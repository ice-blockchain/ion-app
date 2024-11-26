// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/auth/views/components/user_data_inputs/general_user_data_input.dart';
import 'package:ion/generated/assets.gen.dart';

class WebsiteInput extends StatelessWidget {
  const WebsiteInput({
    super.key,
    this.controller,
    this.onChanged,
    this.initialValue,
  });

  final TextEditingController? controller;

  final void Function(String)? onChanged;

  final String? initialValue;

  @override
  Widget build(BuildContext context) {
    return GeneralUserDataInput(
      controller: controller,
      onChanged: onChanged,
      prefixIconAssetName: Assets.svg.iconArticleLink,
      labelText: context.i18n.profile_website,
      initialValue: initialValue,
    );
  }
}
