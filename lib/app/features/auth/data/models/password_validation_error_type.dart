// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/extensions/build_context.dart';
import 'package:ion/app/utils/validators.dart';

const _minPasswordLength = 8;

enum PasswordValidationErrorType {
  notLongEnough,
  noDigits,
  shouldHaveBothUppercaseAndLowercase,
  noSpecialCharacter;

  String getDisplayName(BuildContext context) {
    return switch (this) {
      PasswordValidationErrorType.notLongEnough =>
        context.i18n.error_input_length(_minPasswordLength),
      PasswordValidationErrorType.noDigits => context.i18n.error_input_numbers,
      PasswordValidationErrorType.shouldHaveBothUppercaseAndLowercase =>
        context.i18n.error_input_all_cases,
      PasswordValidationErrorType.noSpecialCharacter => context.i18n.error_input_special_character,
    };
  }

  bool isInvalid(String? password) {
    return switch (this) {
      PasswordValidationErrorType.notLongEnough =>
        Validators.isInvalidLength(password, minLength: _minPasswordLength),
      PasswordValidationErrorType.noDigits => Validators.hasNoDigits(password),
      PasswordValidationErrorType.shouldHaveBothUppercaseAndLowercase =>
        Validators.hasNoUppercaseOrLowercaseLetters(password),
      PasswordValidationErrorType.noSpecialCharacter => Validators.hasNoSpecialChars(password),
    };
  }
}
