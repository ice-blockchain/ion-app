import 'package:flutter/material.dart';
import 'package:ice/app/extensions/extensions.dart';

enum PhoneSetupSteps {
  input,
  confirmation,
  success;

  double get progressValue => switch (this) {
        PhoneSetupSteps.input => 0.5,
        PhoneSetupSteps.confirmation => 0.9,
        PhoneSetupSteps.success => 1.0,
      };

  String? getAppBarTitle(BuildContext context) {
    return switch (this) {
      PhoneSetupSteps.input => context.i18n.common_step_1,
      PhoneSetupSteps.confirmation => context.i18n.common_step_2,
      PhoneSetupSteps.success => null,
    };
  }

  String getPageTitle(BuildContext context) {
    return switch (this) {
      PhoneSetupSteps.input || PhoneSetupSteps.success => context.i18n.phone_verification_title,
      PhoneSetupSteps.confirmation => context.i18n.phone_confirmation_title,
    };
  }

  String getDescription(BuildContext context) {
    return switch (this) {
      PhoneSetupSteps.input => context.i18n.phone_verification_description,
      PhoneSetupSteps.confirmation => context.i18n.two_fa_code_confirmation,
      PhoneSetupSteps.success => '',
    };
  }

  String getButtonText(BuildContext context) {
    return switch (this) {
      PhoneSetupSteps.input => context.i18n.button_next,
      PhoneSetupSteps.confirmation => context.i18n.button_confirm,
      PhoneSetupSteps.success => context.i18n.button_back_to_security,
    };
  }
}
