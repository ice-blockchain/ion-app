// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/generated/assets.gen.dart';

enum VisibilitySettingsOptions {
  everyone,
  followedAccounts,
  verifiedAccounts,
  mentionedAccounts,
  ;

  String getTitle(BuildContext context, {bool isForStory = false}) {
    return switch (this) {
      VisibilitySettingsOptions.everyone => isForStory
          ? context.i18n.visibility_settings_story_everyone
          : context.i18n.visibility_settings_everyone,
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

    return icon.icon(color: context.theme.appColors.primaryAccent);
  }
}
