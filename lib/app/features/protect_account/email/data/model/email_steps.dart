import 'package:flutter/material.dart';
import 'package:ice/app/extensions/extensions.dart';

enum EmailSetupSteps {
  input,
  confirmation,
  success;

  double get progressValue => switch (this) {
        EmailSetupSteps.input => 0.25,
        EmailSetupSteps.confirmation => 0.5,
        EmailSetupSteps.success => 1.0,
      };

  String? getAppBarTitle(BuildContext context) {
    return switch (this) {
      EmailSetupSteps.input => context.i18n.common_step_1,
      EmailSetupSteps.confirmation => context.i18n.common_step_2,
      EmailSetupSteps.success => null,
    };
  }

  String getPageTitle(BuildContext context) {
    return switch (this) {
      EmailSetupSteps.input || EmailSetupSteps.success => context.i18n.email_verification_title,
      EmailSetupSteps.confirmation => context.i18n.email_confirmation_title,
    };
  }

  String getDescription(BuildContext context) {
    return switch (this) {
      EmailSetupSteps.input => context.i18n.email_verification_description,
      EmailSetupSteps.confirmation => context.i18n.two_fa_code_confirmation,
      EmailSetupSteps.success => '',
    };
  }

  String getButtonText(BuildContext context) {
    return switch (this) {
      EmailSetupSteps.input => context.i18n.button_next,
      EmailSetupSteps.confirmation => context.i18n.button_confirm,
      EmailSetupSteps.success => context.i18n.button_back_to_security,
    };
  }
}
