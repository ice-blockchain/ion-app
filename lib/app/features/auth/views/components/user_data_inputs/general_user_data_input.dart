// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/components/inputs/text_input/components/text_input_icons.dart';
import 'package:ion/app/components/inputs/text_input/text_input.dart';
import 'package:ion/app/extensions/extensions.dart';

class GeneralUserDataInput extends StatelessWidget {
  const GeneralUserDataInput({
    required this.prefixIconAssetName,
    required this.labelText,
    this.controller,
    this.onChanged,
    this.validator,
    this.maxLines = 1,
    this.minLines,
    this.textInputAction,
    this.initialValue,
    super.key,
  });

  final String prefixIconAssetName;
  final String labelText;
  final TextEditingController? controller;
  final void Function(String)? onChanged;
  final FormFieldValidator<String>? validator;
  final int? maxLines;
  final int? minLines;
  final TextInputAction? textInputAction;
  final String? initialValue;

  @override
  Widget build(BuildContext context) {
    return TextInput(
      prefixIcon: TextInputIcons(
        hasRightDivider: true,
        icons: [prefixIconAssetName.icon(color: context.theme.appColors.secondaryText)],
      ),
      onChanged: onChanged,
      labelText: labelText,
      controller: controller,
      validator: validator,
      textInputAction: textInputAction ?? TextInputAction.next,
      scrollPadding: EdgeInsets.all(120.0.s),
      maxLines: maxLines,
      minLines: minLines,
      initialValue: initialValue,
    );
  }
}
