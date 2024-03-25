import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ice/app/components/inputs/text_input/components/text_input_border.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/extensions/theme_data.dart';

class TextInput extends HookWidget {
  const TextInput({
    super.key,
    required this.onTextChanged,
  });

  final Function(String) onTextChanged;

  @override
  Widget build(BuildContext context) {
    final TextEditingController controller = useTextEditingController();

    return TextFormField(
      controller: controller,
      style: context.theme.appTextThemes.body.copyWith(
        color: context.theme.appColors.primaryText,
      ),
      cursorColor: context.theme.appColors.primaryAccent,
      decoration: InputDecoration(
        isDense: true,
        contentPadding:
            EdgeInsets.symmetric(vertical: 13.0.s, horizontal: 16.0.s),
        enabledBorder: TextInputBorder(
          borderSide: BorderSide(
            color: context.theme.appColors.primaryBackground,
          ),
          borderRadius: BorderRadius.circular(16.0.s),
        ),
        focusedBorder: TextInputBorder(
          borderSide: BorderSide(
            color: context.theme.appColors.primaryAccent,
          ),
          borderRadius: BorderRadius.circular(16.0.s),
        ),
        filled: true,
        fillColor: context.theme.appColors.primaryBackground,
        label: Text(
          'Email Address',
          style: context.theme.appTextThemes.body,
        ),
        labelStyle: context.theme.appTextThemes.body.copyWith(
          color: context.theme.appColors.tertararyText,
        ),
        floatingLabelStyle: context.theme.appTextThemes.caption.copyWith(
          color: context.theme.appColors.primaryAccent,
        ),
      ),
    );
  }
}
