// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/auth/views/components/user_data_inputs/general_user_data_input.dart';
import 'package:ion/generated/assets.gen.dart';

class DescInput extends StatelessWidget {
  const DescInput({required this.controller, super.key});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return GeneralUserDataInput(
      controller: controller,
      prefixIconAssetName: Assets.svg.iconChannelDescription,
      labelText: context.i18n.common_desc,
      minLines: 1,
      maxLines: 5,
    );
  }
}