import 'package:flutter/material.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/generated/assets.gen.dart';

enum AuthenticatorSteps {
  options,
  instruction,
  confirmation,
  success;

  AssetGenImage get headerImageAsset {
    return switch (this) {
      AuthenticatorSteps.options => Assets.images.icons.icon2faAuthsetup,
      AuthenticatorSteps.instruction => Assets.images.icons.icon2faFollowinstuction,
      AuthenticatorSteps.confirmation => Assets.images.icons.iconLoginPassword,
      AuthenticatorSteps.success => Assets.images.icons.icon2faAuthsetup,
    };
  }

  String? getAppBarTitle(BuildContext context) {
    return switch (this) {
      AuthenticatorSteps.options => context.i18n.common_step_1,
      AuthenticatorSteps.instruction => context.i18n.common_step_2,
      AuthenticatorSteps.confirmation => context.i18n.common_step_3,
      AuthenticatorSteps.success => null,
    };
  }

  String getPageTitle(BuildContext context) {
    return switch (this) {
      AuthenticatorSteps.options => context.i18n.authenticator_setup_title,
      AuthenticatorSteps.instruction => context.i18n.follow_instructions_title,
      AuthenticatorSteps.confirmation => context.i18n.confirm_the_code_title,
      AuthenticatorSteps.success => context.i18n.authenticator_setup_title,
    };
  }

  String getDescription(BuildContext context) {
    return switch (this) {
      AuthenticatorSteps.options => context.i18n.authenticator_setup_description,
      AuthenticatorSteps.instruction => context.i18n.follow_instructions_description,
      AuthenticatorSteps.confirmation => '',
      AuthenticatorSteps.success => '',
    };
  }

  String getButtonText(BuildContext context) {
    return switch (this) {
      AuthenticatorSteps.options || AuthenticatorSteps.instruction => context.i18n.button_next,
      AuthenticatorSteps.confirmation => context.i18n.button_confirm,
      AuthenticatorSteps.success => context.i18n.button_back_to_security,
    };
  }
}

enum AutethenticatorType {
  google,
  micsrosoft,
  lastpass,
  authy,
  userLockPush,
  test1,
  test2,
  test3,
  test4,
  test5;

  String getDisplayName(BuildContext context) {
    return switch (this) {
      AutethenticatorType.google => 'Google Authenticator',
      AutethenticatorType.micsrosoft => 'Microsoft Authenticator',
      AutethenticatorType.lastpass => 'LastPass Authenticator',
      AutethenticatorType.authy => 'Authy',
      AutethenticatorType.userLockPush => 'UserLock Push',
      AutethenticatorType.test1 => 'Test 1',
      AutethenticatorType.test2 => 'Test 2',
      AutethenticatorType.test3 => 'Test 3',
      AutethenticatorType.test4 => 'Test 4',
      AutethenticatorType.test5 => 'Test 5',
    };
  }

  AssetGenImage get iconAsset {
    return switch (this) {
      AutethenticatorType.google => Assets.images.icons.icon2faGoogleauth,
      AutethenticatorType.micsrosoft => Assets.images.icons.icon2famicrosoft,
      AutethenticatorType.lastpass => Assets.images.icons.icon2faLastpass,
      AutethenticatorType.authy => Assets.images.icons.icon2faAuthy,
      AutethenticatorType.userLockPush => Assets.images.icons.icon2faUserlock,
      AutethenticatorType.test1 => Assets.images.icons.icon2faGoogleauth,
      AutethenticatorType.test2 => Assets.images.icons.icon2famicrosoft,
      AutethenticatorType.test3 => Assets.images.icons.icon2faLastpass,
      AutethenticatorType.test4 => Assets.images.icons.icon2faAuthy,
      AutethenticatorType.test5 => Assets.images.icons.icon2faUserlock,
    };
  }
}
