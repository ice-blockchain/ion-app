import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class CodeFields extends StatelessWidget {
  const CodeFields({
    super.key,
    this.controller,
    this.errorAnimationController,
  });

  final TextEditingController? controller;

  final StreamController<ErrorAnimationType>? errorAnimationController;

  @override
  Widget build(BuildContext context) {
    return PinCodeTextField(
      appContext: context,
      length: 4,
      animationType: AnimationType.fade,
      enabled: false,
      cursorColor: Colors.black,
      cursorWidth: 3.0.s,
      cursorHeight: 25.0.s,
      textStyle: context.theme.appTextThemes.inputFieldText,
      pinTheme: PinTheme(
        shape: PinCodeFieldShape.box,
        borderRadius: BorderRadius.circular(16.0.s),
        fieldHeight: 56.0.s,
        fieldWidth: 50.0.s,
        borderWidth: 1,
        inactiveColor: context.theme.appColors.strokeElements,
        disabledColor: context.theme.appColors.strokeElements,
        activeColor: context.theme.appColors.primaryAccent,
        errorBorderColor: context.theme.appColors.attentionRed,
        activeFillColor: Colors.white,
        inactiveFillColor: Colors.white,
        selectedFillColor: Colors.white,
        errorBorderWidth: 1,
        activeBorderWidth: 1,
        inactiveBorderWidth: 1,
        disabledBorderWidth: 1,
        selectedBorderWidth: 1,
      ),
      animationDuration: const Duration(milliseconds: 300),
      keyboardType: TextInputType.number,
      errorAnimationController: errorAnimationController,
      controller: controller,
      onCompleted: (String completed) {},
      onChanged: (String text) {},
      beforeTextPaste: (String? text) {
        return true;
      },
    );
  }
}
