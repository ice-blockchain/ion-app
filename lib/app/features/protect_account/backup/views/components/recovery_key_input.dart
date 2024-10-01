// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ice/app/components/inputs/text_input/components/text_input_icons.dart';
import 'package:ice/app/components/inputs/text_input/text_input.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/generated/assets.gen.dart';

class RecoveryKeyInput extends HookWidget {
  const RecoveryKeyInput({
    required this.controller,
    required this.labelText,
    required this.prefixIcon,
    this.validator,
    this.textInputAction = TextInputAction.next,
    this.scrollPadding,
    super.key,
  });

  final TextEditingController controller;
  final String labelText;
  final Widget prefixIcon;
  final String? Function(String?)? validator;
  final TextInputAction textInputAction;
  final EdgeInsets? scrollPadding;

  @override
  Widget build(BuildContext context) {
    final isValid = useState(false);

    final validate = useCallback(
      (String? value) {
        final error = validator?.call(value);
        isValid.value = (value?.isNotEmpty ?? false) && error == null;
        return error;
      },
      [validator],
    );

    useEffect(
      () {
        validate(controller.text);
        return null;
      },
      [],
    );

    return TextInput(
      controller: controller,
      labelText: labelText,
      prefixIcon: TextInputIcons(
        hasRightDivider: true,
        icons: [prefixIcon],
      ),
      suffixIcon: isValid.value
          ? TextInputIcons(
              icons: [Assets.svg.iconBlockCheckboxOn.icon()],
            )
          : null,
      validator: validate,
      textInputAction: textInputAction,
      scrollPadding: scrollPadding ?? EdgeInsets.only(bottom: 200.0.s),
      verified: isValid.value,
      onChanged: validate,
    );
  }
}
