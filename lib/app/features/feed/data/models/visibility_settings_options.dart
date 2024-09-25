import 'package:flutter/material.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/generated/assets.gen.dart';

enum VisibilitySettingsOptions {
  everyone,
  followedAccounts,
  verifiedAccounts,
  mentionedAccounts,
  ;

  String getTitle(BuildContext context) {
    return switch (this) {
      VisibilitySettingsOptions.everyone => context.i18n.visibility_settings_everyone,
      VisibilitySettingsOptions.followedAccounts =>
        context.i18n.visibility_settings_followed_accounts,
      VisibilitySettingsOptions.verifiedAccounts =>
        context.i18n.visibility_settings_verified_accounts,
      VisibilitySettingsOptions.mentionedAccounts =>
        context.i18n.visibility_settings_mentioned_accounts,
    };
  }

  Widget getIcon(BuildContext context) {
    final icon = switch (this) {
      VisibilitySettingsOptions.everyone => Assets.svg.iconPostEveryone,
      VisibilitySettingsOptions.followedAccounts => Assets.svg.iconSearchFollow,
      VisibilitySettingsOptions.verifiedAccounts => Assets.svg.iconPostVerifyaccount,
      VisibilitySettingsOptions.mentionedAccounts => Assets.svg.iconFieldNickname,
    };

    return icon.icon(size: 24.0.s, color: context.theme.appColors.primaryAccent);
  }
}
