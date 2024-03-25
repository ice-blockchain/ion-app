import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ice/app/components/inputs/text_input/components/text_input_decoration.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/extensions/string.dart';
import 'package:ice/app/extensions/theme_data.dart';

class TextInput extends HookWidget {
  TextInput({
    super.key,
    this.controller,
    this.validator,
    this.keyboardType,
    this.labelText,
    this.initialValue,
    this.errorText,
    this.maxLines = 1,
    this.minLines,
    this.verified = false,
    this.enabled = true,
    this.prefixIcon,
    this.suffixIcon,
    this.onChanged,
    EdgeInsetsGeometry? contentPadding,
  }) : contentPadding = contentPadding ??
            EdgeInsets.symmetric(
              vertical: defaultContentVerticalOffset,
              horizontal: defaultContentHorizontalOffset,
            );

  static double get defaultContentHorizontalOffset => 16.0.s;
  static double get defaultContentVerticalOffset => 13.0.s;

  final TextEditingController? controller;
  final FormFieldValidator<String>? validator;

  final TextInputType? keyboardType;

  final String? labelText;
  final String? errorText;
  final String? initialValue;

  final int? maxLines;
  final int? minLines;

  final bool enabled;
  final bool verified;

  final Widget? prefixIcon;
  final Widget? suffixIcon;

  final EdgeInsetsGeometry? contentPadding;

  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<String?> error = useState(null);

    return TextFormField(
      controller: controller,
      initialValue: initialValue,
      maxLines: maxLines,
      minLines: minLines,
      enabled: enabled,
      keyboardType: keyboardType,
      style: context.theme.appTextThemes.body.copyWith(
        color: context.theme.appColors.primaryText,
      ),
      cursorErrorColor: context.theme.appColors.primaryAccent,
      cursorColor: context.theme.appColors.primaryAccent,
      validator: (String? value) {
        final String? validatorError = validator?.call(value);
        WidgetsBinding.instance.addPostFrameCallback((_) {
          error.value = validatorError;
        });
        return null;
      },
      onChanged: (String value) {
        onChanged?.call(value);
        error.value = null;
      },
      decoration: TextInputDecoration(
        context: context,
        verified: verified,
        suffixIcon: prefixIcon,
        prefixIcon: prefixIcon,
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
