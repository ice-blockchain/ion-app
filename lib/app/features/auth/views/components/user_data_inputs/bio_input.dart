// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/auth/views/components/user_data_inputs/general_user_data_input.dart';
import 'package:ion/generated/assets.gen.dart';

class BioInput extends StatelessWidget {
  const BioInput({this.controller, super.key, this.onChanged, this.initialValue});

  final TextEditingController? controller;

  final void Function(String)? onChanged;

  final String? initialValue;

  @override
  Widget build(BuildContext context) {
    return GeneralUserDataInput(
      controller: controller,
      onChanged: onChanged,
      initialValue: initialValue,
      prefixIconAssetName: Assets.svg.iconProfileBio,
      labelText: context.i18n.profile_bio,
      textInputAction: TextInputAction.newline,
      minLines: 1,
      maxLines: 5,
    );
  }
}
