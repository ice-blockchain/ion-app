// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ion/app/components/inputs/hooks/use_node_focused.dart';
import 'package:ion/app/components/inputs/hooks/use_text_changed.dart';
import 'package:ion/app/components/inputs/text_input/components/text_input_decoration.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/hooks/use_on_init.dart';

class TextInput extends HookWidget {
  TextInput({
    super.key,
    this.controller,
    this.validator,
    this.textInputAction,
    this.keyboardType,
    this.inputFormatters,
    this.labelText,
    this.initialValue,
    this.errorText,
    this.maxLines = 1,
    this.minLines,
    this.verified = false,
    this.enabled = true,
    this.numbersOnly = false,
    this.prefix,
    this.prefixIcon,
    this.suffixIcon,
    this.onChanged,
    this.onValidated,
    this.onFocused,
    this.maxLength,
    this.isLive = false,
    this.alwaysShowPrefixIcon = false,
    this.obscureText = false,
    EdgeInsets? scrollPadding,
    EdgeInsetsGeometry? contentPadding,
  })  : scrollPadding = scrollPadding ?? EdgeInsets.all(20.0.s),
        contentPadding =
            contentPadding ?? EdgeInsets.symmetric(vertical: 13.0.s, horizontal: 16.0.s);

  final TextEditingController? controller;
  final FormFieldValidator<String>? validator;
  final TextInputAction? textInputAction;

  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;

  final String? labelText;
  final String? errorText;
  final String? initialValue;

  final int? maxLines;
  final int? minLines;

  final bool enabled;
  final bool verified;
  final bool numbersOnly;

  final Widget? prefix;
  final Widget? prefixIcon;
  final Widget? suffixIcon;

  final EdgeInsets scrollPadding;
  final EdgeInsetsGeometry contentPadding;

  final ValueChanged<String>? onChanged;
  final ValueChanged<bool>? onValidated;
  final ValueChanged<bool>? onFocused;
  final bool alwaysShowPrefixIcon;
  final int? maxLength;
  final bool isLive;
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    final focusNode = useFocusNode();
    final error = useState<String?>(null);
    final hasValue = useState(initialValue.isNotEmpty);
    final hasFocus = useNodeFocused(focusNode);
    final hasBeenChanged = useState(false);

    useOnInit(
      () {
        onFocused?.call(hasFocus.value);
      },
      [hasFocus.value],
    );

    String? validate(String? value) {
      final validatorError = validator?.call(value);
      hasBeenChanged.value = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        error.value = validatorError;
        onValidated?.call(validatorError == null);
      });
      return validatorError;
    }

    void onChangedHandler(String text) {
      hasValue.value = text.isNotEmpty;
      onChanged?.call(text);
      if (isLive) {
        validate(text);
      }
      hasBeenChanged.value;
    }

    useTextChanged(
      controller: controller,
      onTextChanged: onChangedHandler,
    );

    return TextFormField(
      scrollPadding: scrollPadding,
      controller: controller,
      focusNode: focusNode,
      onChanged: controller == null ? onChangedHandler : null,
      initialValue: initialValue,
      maxLines: maxLines,
      minLines: minLines,
      enabled: enabled,
      textInputAction: textInputAction,
      keyboardType: numbersOnly ? TextInputType.number : keyboardType,
      inputFormatters: numbersOnly
          ? <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly,
            ]
          : inputFormatters,
      style: context.theme.appTextThemes.body.copyWith(
        color: context.theme.appColors.primaryText,
      ),
      cursorErrorColor: context.theme.appColors.primaryAccent,
      cursorColor: context.theme.appColors.primaryAccent,
      maxLength: maxLength,
      obscureText: obscureText,
      obscuringCharacter: '*',
      validator: validate,
      decoration: TextInputDecoration(
        context: context,
        verified: verified,
        prefix: prefix,
        prefixIcon:
            alwaysShowPrefixIcon || (!hasFocus.value && !hasValue.value) ? prefixIcon : null,
        suffixIcon: suffixIcon,
        errorText: errorText ?? error.value,
        contentPadding: contentPadding,
        labelText: errorText.isNotEmpty
            ? errorText
            : error.value.isNotEmpty
                ? error.value
                : labelText,
      ),
    );
  }
}
