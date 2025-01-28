// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/extensions/extensions.dart';

enum EmailEditSteps {
  input,
  confirmation,
  twoFaOptions,
  twoFaInput,
  success;

  double get progressValue => switch (this) {
        EmailEditSteps.input => 0.2,
        EmailEditSteps.confirmation => 0.4,
        EmailEditSteps.twoFaOptions => 0.6,
        EmailEditSteps.twoFaInput => 0.8,
        EmailEditSteps.success => 1.0,
      };

  String getPageTitle(BuildContext context) {
    return switch (this) {
      EmailEditSteps.input || EmailEditSteps.success => context.i18n.email_verification_title,
      EmailEditSteps.twoFaOptions ||
      EmailEditSteps.twoFaInput =>
        context.i18n.two_fa_edit_email_title,
      EmailEditSteps.confirmation => context.i18n.email_confirmation_title,
    };
  }

  String getDescription(BuildContext context) {
    return switch (this) {
      EmailEditSteps.input => context.i18n.email_verification_description,
      EmailEditSteps.twoFaOptions ||
      EmailEditSteps.twoFaInput =>
        context.i18n.two_fa_edit_email_description,
      EmailEditSteps.confirmation => context.i18n.two_fa_code_confirmation,
      EmailEditSteps.success => '',
    };
  }

  String getButtonText(BuildContext context) {
    return switch (this) {
      EmailEditSteps.input || EmailEditSteps.twoFaOptions => context.i18n.button_next,
      EmailEditSteps.confirmation || EmailEditSteps.twoFaInput => context.i18n.button_confirm,
      EmailEditSteps.success => context.i18n.button_back_to_security,
    };
  }
}
