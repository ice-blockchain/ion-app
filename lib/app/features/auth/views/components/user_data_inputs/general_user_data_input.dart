// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ion/app/components/inputs/text_input/components/text_input_icons.dart';
import 'package:ion/app/components/inputs/text_input/text_input.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/generated/assets.gen.dart';

class GeneralUserDataInput extends HookWidget {
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
    this.isLive = false,
    this.showNoErrorsIndicator = false,
    this.prefix,
    super.key,
  });

  final String prefixIconAssetName;
  final String labelText;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final FormFieldValidator<String>? validator;
  final int? maxLines;
  final int? minLines;
  final TextInputAction? textInputAction;
  final String? initialValue;
  final bool isLive;
  final bool showNoErrorsIndicator;
  final Widget? prefix;

  @override
  Widget build(BuildContext context) {
    final isValid = useState(false);

    return TextInput(
      prefixIcon: TextInputIcons(
        hasRightDivider: true,
        icons: [prefixIconAssetName.icon(color: context.theme.appColors.secondaryText)],
      ),
      onChanged: onChanged,
      prefix: prefix,
      onValidated: (value) => isValid.value = value,
      labelText: labelText,
      controller: controller,
      validator: validator,
      textInputAction: textInputAction ?? TextInputAction.next,
      scrollPadding: EdgeInsetsDirectional.all(120.0.s),
      maxLines: maxLines,
      minLines: minLines,
      initialValue: initialValue,
      isLive: isLive,
      verified: isValid.value,
      onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
      suffixIcon: isValid.value && showNoErrorsIndicator
          ? TextInputIcons(
              icons: [Assets.svg.iconBlockCheckboxOn.icon()],
            )
          : null,
    );
  }
}
