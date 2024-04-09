import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    EdgeInsets? scrollPadding,
    EdgeInsetsGeometry? contentPadding,
  })  : scrollPadding = scrollPadding ?? EdgeInsets.all(20.0.s),
        contentPadding = contentPadding ??
            EdgeInsets.symmetric(vertical: 13.0.s, horizontal: 16.0.s);

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

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<String?> error = useState(null);

    useEffect(
      () {
        void listener() {
          onChanged?.call(controller?.text ?? '');
        }

        WidgetsBinding.instance.addPostFrameCallback(
          (_) => controller?.addListener(listener),
        );
        return () => controller?.removeListener(listener);
      },
      <Object?>[controller, onChanged],
    );

    return TextFormField(
      scrollPadding: scrollPadding,
      controller: controller,
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
      validator: (String? value) {
        final String? validatorError = validator?.call(value);
        WidgetsBinding.instance.addPostFrameCallback((_) {
          error.value = validatorError;
        });
        return validatorError;
      },
      decoration: TextInputDecoration(
        context: context,
        verified: verified,
        prefix: prefix,
        prefixIcon: prefixIcon,
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
