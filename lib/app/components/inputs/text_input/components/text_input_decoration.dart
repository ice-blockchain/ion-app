// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ice/app/components/inputs/text_input/components/text_input_border.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/theme_data.dart';

class TextInputDecoration extends InputDecoration {
  TextInputDecoration({
    required BuildContext context,
    required bool verified,
    super.errorText,
    super.contentPadding,
    super.labelText,
    super.prefix,
    super.prefixIcon,
    super.suffixIcon,
  }) : super(
          isDense: true,
          prefixIconConstraints: const BoxConstraints(),
          suffixIconConstraints: const BoxConstraints(),
          enabledBorder: TextInputBorder(
            borderSide: BorderSide(
              color: verified
                  ? context.theme.appColors.success
                  : context.theme.appColors.strokeElements,
            ),
          ),
          disabledBorder: TextInputBorder(
            borderSide: BorderSide(color: context.theme.appColors.primaryBackground),
          ),
          focusedBorder: TextInputBorder(
            borderSide: BorderSide(
              color: verified
                  ? context.theme.appColors.success
                  : context.theme.appColors.primaryAccent,
            ),
          ),
          errorBorder: TextInputBorder(
            borderSide: BorderSide(color: context.theme.appColors.attentionRed),
          ),
          focusedErrorBorder: TextInputBorder(
            borderSide: BorderSide(color: context.theme.appColors.attentionRed),
          ),
          filled: true,
          fillColor: WidgetStateColor.resolveWith((Set<WidgetState> states) {
            return states.contains(WidgetState.disabled)
                ? context.theme.appColors.onSecondaryBackground
                : context.theme.appColors.secondaryBackground;
          }),
          labelStyle: context.theme.appTextThemes.body.copyWith(
            color: context.theme.appColors.tertararyText,
          ),
          prefixStyle: context.theme.appTextThemes.body.copyWith(
            color: context.theme.appColors.primaryText,
          ),
          errorStyle: const TextStyle(fontSize: 0),
          floatingLabelStyle: WidgetStateTextStyle.resolveWith((Set<WidgetState> states) {
            return context.theme.appTextThemes.subtitle2.copyWith(
              color: states.contains(WidgetState.error)
                  ? context.theme.appColors.attentionRed
                  : states.contains(WidgetState.focused)
                      ? context.theme.appColors.primaryAccent
                      : context.theme.appColors.tertararyText,
              height: 1,
            );
          }),
        );
}
