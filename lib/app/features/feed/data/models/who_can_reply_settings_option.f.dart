// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.f.dart';
import 'package:ion/generated/assets.gen.dart';

part 'who_can_reply_settings_option.f.freezed.dart';

@freezed
class WhoCanReplySettingsOption with _$WhoCanReplySettingsOption {
  const factory WhoCanReplySettingsOption.everyone() = _Everyone;

  const factory WhoCanReplySettingsOption.followedAccounts() = _FollowedAccounts;

  const factory WhoCanReplySettingsOption.mentionedAccounts() = _MentionedAccounts;

  const factory WhoCanReplySettingsOption.accountsWithBadge({
    required ReplaceableEventReference badge,
  }) = _AccountsWithBadge;

  /// Parses a tag value of the form
  /// - "everyone"
  /// - "following"
  /// - "mentioned"
  /// - "badge|<eventRef>"
  factory WhoCanReplySettingsOption.fromTagValue(String value) {
    if (value.startsWith('badge|')) {
      final parts = value.split('|');
      final ref = ReplaceableEventReference.fromString(parts[1]);
      return WhoCanReplySettingsOption.accountsWithBadge(badge: ref);
    }
    switch (value) {
      case 'following':
        return const WhoCanReplySettingsOption.followedAccounts();
      case 'mentioned':
        return const WhoCanReplySettingsOption.mentionedAccounts();
      case 'everyone':
      default:
        return const WhoCanReplySettingsOption.everyone();
    }
  }
}

extension WhoCanReplySettingsOptionX on WhoCanReplySettingsOption {
  String get tagValue => when(
        everyone: () => 'everyone',
        followedAccounts: () => 'following',
        mentionedAccounts: () => 'mentioned',
        accountsWithBadge: (badge) => 'badge|$badge',
      );

  String getTitle(BuildContext context) => when(
        everyone: () => context.i18n.who_can_reply_settings_everyone,
        followedAccounts: () => context.i18n.who_can_reply_settings_followed_accounts,
        mentionedAccounts: () => context.i18n.who_can_reply_settings_mentioned_accounts,
        accountsWithBadge: (_) => context.i18n.who_can_reply_settings_verified_accounts,
      );

  Widget getIcon(BuildContext context) {
    final asset = when(
      everyone: () => Assets.svg.iconPostEveryone,
      followedAccounts: () => Assets.svg.iconSearchFollow,
      mentionedAccounts: () => Assets.svg.iconFieldNickname,
      accountsWithBadge: (_) => Assets.svg.iconPostVerifyaccount,
    );
    return asset.icon(color: context.theme.appColors.primaryAccent);
  }
}
