// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/generated/assets.gen.dart';

enum WhoCanReplySettingsOption {
  everyone,
  followedAccounts,
  verifiedAccounts,
  mentionedAccounts;

  String getTitle(BuildContext context) {
    return switch (this) {
      WhoCanReplySettingsOption.everyone => context.i18n.visibility_settings_everyone,
      WhoCanReplySettingsOption.followedAccounts =>
        context.i18n.visibility_settings_followed_accounts,
      WhoCanReplySettingsOption.verifiedAccounts =>
        context.i18n.visibility_settings_verified_accounts,
      WhoCanReplySettingsOption.mentionedAccounts =>
        context.i18n.visibility_settings_mentioned_accounts,
    };
  }

  Widget getIcon(BuildContext context) {
    final icon = switch (this) {
      WhoCanReplySettingsOption.everyone => Assets.svg.iconPostEveryone,
      WhoCanReplySettingsOption.followedAccounts => Assets.svg.iconSearchFollow,
      WhoCanReplySettingsOption.verifiedAccounts => Assets.svg.iconPostVerifyaccount,
      WhoCanReplySettingsOption.mentionedAccounts => Assets.svg.iconFieldNickname,
    };

    return icon.icon(color: context.theme.appColors.primaryAccent);
  }

  String? toValue() {
    return switch (this) {
      WhoCanReplySettingsOption.followedAccounts => 'following',
      WhoCanReplySettingsOption.mentionedAccounts => 'mentioned',
      // TODO: Add verified accounts option when API is ready
      WhoCanReplySettingsOption.verifiedAccounts => null,
      WhoCanReplySettingsOption.everyone => null,
    };
  }
}
