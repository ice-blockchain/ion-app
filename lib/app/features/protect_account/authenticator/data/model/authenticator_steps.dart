// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/generated/assets.gen.dart';

enum AuthenticatorSetupSteps {
  options,
  instruction,
  confirmation,
  success;

  double get progressValue => switch (this) {
        AuthenticatorSetupSteps.options => 0.25,
        AuthenticatorSetupSteps.instruction => 0.7,
        AuthenticatorSetupSteps.confirmation => 0.9,
        AuthenticatorSetupSteps.success => 1.0
      };

  String get headerImageAsset {
    return switch (this) {
      AuthenticatorSetupSteps.options => Assets.svg.icon2faAuthsetup,
      AuthenticatorSetupSteps.instruction => Assets.svg.icon2faFollowinstuction,
      AuthenticatorSetupSteps.confirmation => Assets.svg.iconLoginPassword,
      AuthenticatorSetupSteps.success => Assets.svg.icon2faAuthsetup,
    };
  }

  String getPageTitle(BuildContext context) {
    return switch (this) {
      AuthenticatorSetupSteps.options => context.i18n.authenticator_setup_title,
      AuthenticatorSetupSteps.instruction => context.i18n.follow_instructions_title,
      AuthenticatorSetupSteps.confirmation => context.i18n.confirm_the_code_title,
      AuthenticatorSetupSteps.success => context.i18n.authenticator_setup_title,
    };
  }

  String getDescription(BuildContext context) {
    return switch (this) {
      AuthenticatorSetupSteps.options => context.i18n.authenticator_setup_description,
      AuthenticatorSetupSteps.instruction => context.i18n.follow_instructions_description,
      AuthenticatorSetupSteps.confirmation => '',
      AuthenticatorSetupSteps.success => '',
    };
  }

  String getButtonText(BuildContext context) {
    return switch (this) {
      AuthenticatorSetupSteps.options ||
      AuthenticatorSetupSteps.instruction =>
        context.i18n.button_next,
      AuthenticatorSetupSteps.confirmation => context.i18n.button_confirm,
      AuthenticatorSetupSteps.success => context.i18n.button_back_to_security,
    };
  }
}
