import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ice/app/components/inputs/text_input/components/state_borders.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/extensions/string.dart';
import 'package:ice/app/extensions/theme_data.dart';

class TextInput extends HookWidget {
  TextInput({
    super.key,
    this.controller,
    this.validator,
    this.labelText,
    this.initialValue,
    this.errorText,
    this.maxLines = 1,
    this.minLines,
    this.verified = false,
    this.enabled = true,
    this.onChanged,
    EdgeInsetsGeometry? contentPadding,
  }) : contentPadding = contentPadding ??
            EdgeInsets.symmetric(vertical: 13.0.s, horizontal: 16.0.s);

  final TextEditingController? controller;
  final FormFieldValidator<String>? validator;

  final String? labelText;
  final String? errorText;
  final String? initialValue;

  final int? maxLines;
  final int? minLines;

  final bool enabled;
  final bool verified;

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
      decoration: InputDecoration(
        isDense: true,
        errorText: errorText ?? error.value,
        contentPadding: contentPadding,
        enabledBorder: StateBorders.enabledBorder(context, verified: verified),
        disabledBorder: StateBorders.disabledBorder(context),
        focusedBorder: StateBorders.focusedBorder(context, verified: verified),
        errorBorder: StateBorders.errorBorder(context),
        focusedErrorBorder: StateBorders.focusedErrorBorder(context),
        filled: true,
        fillColor: MaterialStateColor.resolveWith((Set<MaterialState> states) {
          return states.contains(MaterialState.disabled)
              ? context.theme.appColors.onSecondaryBackground
              : context.theme.appColors.secondaryBackground;
        }),
        labelText: errorText.isNotEmpty
            ? errorText
            : error.value.isNotEmpty
                ? error.value
                : labelText,
        labelStyle: context.theme.appTextThemes.body.copyWith(
          color: context.theme.appColors.tertararyText,
        ),
        errorStyle: const TextStyle(fontSize: 0),
        floatingLabelStyle:
            MaterialStateTextStyle.resolveWith((Set<MaterialState> states) {
          return context.theme.appTextThemes.subtitle2.copyWith(
            color: states.contains(MaterialState.error)
                ? context.theme.appColors.attentionRed
                : states.contains(MaterialState.focused)
                    ? context.theme.appColors.primaryAccent
                    : context.theme.appColors.tertararyText,
            height: 1,
          );
        }),
      ),
    );
  }
}
