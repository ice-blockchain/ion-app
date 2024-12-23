// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/generated/assets.gen.dart';

enum WhoCanReplySettingsOption {
  everyone(null),
  followedAccounts('following'),
  // TODO: Add support for verified accounts setting when API is ready
  verifiedAccounts(null),
  mentionedAccounts('mentioned');

  const WhoCanReplySettingsOption(this.tagValue);

  final String? tagValue;

  static WhoCanReplySettingsOption fromTagValue(String value) {
    return values.firstWhere((option) => option.tagValue == value, orElse: () => everyone);
  }

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
}
