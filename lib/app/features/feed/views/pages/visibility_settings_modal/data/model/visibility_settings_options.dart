import 'package:flutter/material.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/generated/assets.gen.dart';

enum VisibilitySettingsOptions {
  everyone,
  followed_accounts,
  verified_accounts,
  mentioned_accounts,
  ;

  String getTitle(BuildContext context) {
    return switch (this) {
      VisibilitySettingsOptions.everyone => context.i18n.visibility_settings_everyone,
      VisibilitySettingsOptions.followed_accounts =>
        context.i18n.visibility_settings_followed_accounts,
      VisibilitySettingsOptions.verified_accounts =>
        context.i18n.visibility_settings_verified_accounts,
      VisibilitySettingsOptions.mentioned_accounts =>
        context.i18n.visibility_settings_mentioned_accounts,
    };
  }

  Widget getIcon(BuildContext context) {
    final icon = switch (this) {
      VisibilitySettingsOptions.everyone => Assets.svg.iconPostEveryone,
      VisibilitySettingsOptions.followed_accounts => Assets.svg.iconSearchFollow,
      VisibilitySettingsOptions.verified_accounts => Assets.svg.iconPostVerifyaccount,
      VisibilitySettingsOptions.mentioned_accounts => Assets.svg.iconFieldNickname,
    };

    return icon.icon(size: 24.0.s, color: context.theme.appColors.primaryAccent);
  }
}
