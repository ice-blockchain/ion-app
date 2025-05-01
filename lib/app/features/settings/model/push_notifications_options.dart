// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/push_notifications/data/models/push_notification_category.c.dart';
import 'package:ion/app/features/settings/model/selectable_option.dart';
import 'package:ion/generated/assets.gen.dart';

abstract interface class PushNotificationOption {
  PushNotificationCategory get category;
}

enum SocialNotificationOption implements SelectableOption, PushNotificationOption {
  posts,
  mentionsAndReplies,
  reposts,
  likes,
  newFollowers;

  @override
  String getLabel(BuildContext context) => switch (this) {
        SocialNotificationOption.posts => context.i18n.push_notification_social_option_posts,
        SocialNotificationOption.mentionsAndReplies =>
          context.i18n.push_notification_social_option_mentions_replies,
        SocialNotificationOption.reposts => context.i18n.push_notification_social_option_reposts,
        SocialNotificationOption.likes => context.i18n.push_notification_social_option_likes,
        SocialNotificationOption.newFollowers =>
          context.i18n.push_notification_social_option_new_followers,
      };

  @override
  Widget getIcon(BuildContext context) {
    final icon = switch (this) {
      SocialNotificationOption.posts => Assets.svg.iconProfileFeed,
      SocialNotificationOption.mentionsAndReplies => Assets.svg.iconFieldNickname,
      SocialNotificationOption.reposts => Assets.svg.iconFeedRepost,
      SocialNotificationOption.likes => Assets.svg.iconVideoLikeOff,
      SocialNotificationOption.newFollowers => Assets.svg.iconSearchFollow,
    };

    return icon.icon(color: context.theme.appColors.primaryAccent);
  }

  @override
  PushNotificationCategory get category => switch (this) {
        SocialNotificationOption.posts => PushNotificationCategory.posts,
        SocialNotificationOption.mentionsAndReplies => PushNotificationCategory.mentionsAndReplies,
        SocialNotificationOption.reposts => PushNotificationCategory.reposts,
        SocialNotificationOption.likes => PushNotificationCategory.likes,
        SocialNotificationOption.newFollowers => PushNotificationCategory.newFollowers,
      };
}

enum ChatNotificationOption implements SelectableOption, PushNotificationOption {
  directMessages,
  groupChats,
  channels;

  @override
  String getLabel(BuildContext context) => switch (this) {
        ChatNotificationOption.directMessages =>
          context.i18n.push_notification_chat_option_direct_messages,
        ChatNotificationOption.groupChats => context.i18n.push_notification_chat_option_group_chats,
        ChatNotificationOption.channels => context.i18n.push_notification_chat_option_channels,
      };

  @override
  Widget getIcon(BuildContext context) {
    final icon = switch (this) {
      ChatNotificationOption.directMessages => Assets.svg.iconChatOff,
      ChatNotificationOption.groupChats => Assets.svg.iconSearchGroups,
      ChatNotificationOption.channels => Assets.svg.iconSearchChannel,
    };

    return icon.icon(color: context.theme.appColors.primaryAccent);
  }

  @override
  PushNotificationCategory get category => switch (this) {
        ChatNotificationOption.directMessages => PushNotificationCategory.directMessages,
        ChatNotificationOption.groupChats => PushNotificationCategory.groupChats,
        ChatNotificationOption.channels => PushNotificationCategory.channels,
      };
}

enum WalletNotificationOption implements SelectableOption, PushNotificationOption {
  paymentRequest,
  paymentReceived;

  @override
  String getLabel(BuildContext context) => switch (this) {
        WalletNotificationOption.paymentRequest =>
          context.i18n.push_notification_wallet_option_payment_request,
        WalletNotificationOption.paymentReceived =>
          context.i18n.push_notification_wallet_option_payment_received,
      };

  @override
  Widget getIcon(BuildContext context) {
    final icon = switch (this) {
      WalletNotificationOption.paymentRequest => Assets.svg.iconButtonAddstroke,
      WalletNotificationOption.paymentReceived => Assets.svg.iconButtonReceive,
    };

    return icon.icon(color: context.theme.appColors.primaryAccent);
  }

  @override
  PushNotificationCategory get category => switch (this) {
        WalletNotificationOption.paymentRequest => PushNotificationCategory.paymentRequest,
        WalletNotificationOption.paymentReceived => PushNotificationCategory.paymentReceived,
      };
}

enum SystemNotificationOption implements SelectableOption, PushNotificationOption {
  updates;

  @override
  String getLabel(BuildContext context) => context.i18n.push_notification_system_option_update;

  @override
  Widget getIcon(BuildContext context) {
    return Assets.svg.iconNotificationsUpdates.icon(color: context.theme.appColors.primaryAccent);
  }

  @override
  PushNotificationCategory get category => PushNotificationCategory.updates;
}
