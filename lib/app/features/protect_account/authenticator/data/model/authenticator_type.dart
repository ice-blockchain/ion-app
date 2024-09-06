import 'package:flutter/material.dart';
import 'package:ice/generated/assets.gen.dart';

enum AutethenticatorType {
  google,
  micsrosoft,
  lastpass,
  authy,
  userLockPush;

  String getDisplayName(BuildContext context) {
    return switch (this) {
      AutethenticatorType.google => 'Google Authenticator',
      AutethenticatorType.micsrosoft => 'Microsoft Authenticator',
      AutethenticatorType.lastpass => 'LastPass Authenticator',
      AutethenticatorType.authy => 'Authy',
      AutethenticatorType.userLockPush => 'UserLock Push',
    };
  }

  String get iconAsset {
    return switch (this) {
      AutethenticatorType.google => Assets.svg.icon2faGoogleauth,
      AutethenticatorType.micsrosoft => Assets.svg.icon2famicrosoft,
      AutethenticatorType.lastpass => Assets.svg.icon2faLastpass,
      AutethenticatorType.authy => Assets.svg.icon2faAuthy,
      AutethenticatorType.userLockPush => Assets.svg.icon2faUserlock,
    };
  }
}
