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

  AssetGenImage get iconAsset {
    return switch (this) {
      AutethenticatorType.google => Assets.images.icons.icon2faGoogleauth,
      AutethenticatorType.micsrosoft => Assets.images.icons.icon2famicrosoft,
      AutethenticatorType.lastpass => Assets.images.icons.icon2faLastpass,
      AutethenticatorType.authy => Assets.images.icons.icon2faAuthy,
      AutethenticatorType.userLockPush => Assets.images.icons.icon2faUserlock,
    };
  }
}
