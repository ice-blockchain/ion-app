import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class CodeFields extends StatelessWidget {
  const CodeFields({
    super.key,
    this.enabled = true,
    this.controller,
    this.errorAnimationController,
    this.onCompleted,
    this.onChanged,
    this.invalidCode = false,
  });

  final bool enabled;

  final TextEditingController? controller;

  final StreamController<ErrorAnimationType>? errorAnimationController;

  final void Function(String)? onCompleted;

  final void Function(String)? onChanged;

  final bool invalidCode;

  @override
  Widget build(BuildContext context) {
    return PinCodeTextField(
      mainAxisAlignment: MainAxisAlignment.center,
      appContext: context,
      length: 4,
      animationType: AnimationType.fade,
      enabled: enabled,
      cursorColor: context.theme.appColors.primaryText,
      cursorWidth: 3.0.s,
      cursorHeight: 25.0.s,
      textStyle: context.theme.appTextThemes.inputFieldText,
      autoDisposeControllers: false,
      pinTheme: PinTheme(
        shape: PinCodeFieldShape.box,
        borderRadius: BorderRadius.circular(16.0.s),
        fieldHeight: 56.0.s,
        fieldWidth: 50.0.s,
        borderWidth: 1,
        inactiveColor: invalidCode
            ? context.theme.appColors.attentionRed
            : context.theme.appColors.strokeElements,
        disabledColor: context.theme.appColors.strokeElements,
        activeColor: invalidCode
            ? context.theme.appColors.attentionRed
            : context.theme.appColors.primaryAccent,
        errorBorderColor: context.theme.appColors.attentionRed,
        activeFillColor: context.theme.appColors.secondaryBackground,
        inactiveFillColor: context.theme.appColors.secondaryBackground,
        selectedFillColor: context.theme.appColors.secondaryBackground,
        errorBorderWidth: 1,
        activeBorderWidth: 1,
        inactiveBorderWidth: 1,
        disabledBorderWidth: 1,
        selectedBorderWidth: 1,
        fieldOuterPadding: EdgeInsets.symmetric(horizontal: 8.0.s),
      ),
      animationDuration: const Duration(milliseconds: 300),
      keyboardType: TextInputType.number,
      errorAnimationController: errorAnimationController,
      controller: controller,
      onCompleted: onCompleted,
      onChanged: onChanged,
      beforeTextPaste: (String? text) {
        return true;
      },
    );
  }
}
