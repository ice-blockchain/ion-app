import 'package:flutter/material.dart';
import 'package:ice/app/components/inputs/text_input/components/text_input_border.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/theme_data.dart';

class StateBorders {
  StateBorders._();

  static TextInputBorder enabledBorder(
    BuildContext context, {
    required bool verified,
  }) =>
      TextInputBorder(
        borderSide: BorderSide(
          color: verified
              ? context.theme.appColors.success
              : context.theme.appColors.primaryBackground,
        ),
      );

  static TextInputBorder disabledBorder(BuildContext context) =>
      TextInputBorder(
        borderSide:
            BorderSide(color: context.theme.appColors.primaryBackground),
      );

  static TextInputBorder focusedBorder(
    BuildContext context, {
    required bool verified,
  }) =>
      TextInputBorder(
        borderSide: BorderSide(
          color: verified
              ? context.theme.appColors.success
              : context.theme.appColors.primaryAccent,
        ),
      );

  static TextInputBorder errorBorder(BuildContext context) => TextInputBorder(
        borderSide: BorderSide(color: context.theme.appColors.attentionRed),
      );

  static TextInputBorder focusedErrorBorder(BuildContext context) =>
      TextInputBorder(
        borderSide: BorderSide(color: context.theme.appColors.attentionRed),
      );
}
