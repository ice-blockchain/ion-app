// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/utils/validators.dart';

String? getPasswordStrengthValidationError({
  required String? password,
  required BuildContext context,
}) {
  const minLength = 8;
  if (Validators.isEmpty(password)) {
    return '';
  }

  if (Validators.isInvalidLength(password, minLength: minLength)) {
    return context.i18n.error_input_length(minLength);
  }

  if (!RegExp(r'\d').hasMatch(password!)) {
    return context.i18n.error_input_numbers(1);
  }

  final hasUpper = RegExp('[A-Z]').hasMatch(password);
  final hasLower = RegExp('[a-z]').hasMatch(password);

  if (!(hasUpper && hasLower)) {
    return context.i18n.error_input_all_cases;
  }

  if (!RegExp(r'[^a-zA-Z0-9\s]').hasMatch(password)) {
    return context.i18n.error_input_special_character;
  }

  return null;
}
