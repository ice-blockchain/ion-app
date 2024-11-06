// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/extensions/extensions.dart';

enum DeleteTwoFAStep {
  initial,
  selectOptions,
  input;

  String getAppBarTitle(BuildContext context) {
    return switch (this) {
      DeleteTwoFAStep.selectOptions => context.i18n.common_step_1,
      DeleteTwoFAStep.input => context.i18n.common_step_2,
      _ => '',
    };
  }

  double get progressValue => switch (this) {
        DeleteTwoFAStep.selectOptions => 0.25,
        DeleteTwoFAStep.input => 0.9,
        _ => 0.0,
      };
}
