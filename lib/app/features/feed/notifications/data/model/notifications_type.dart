// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/generated/assets.gen.dart';

enum NotificationsType {
  follow,
  like,
  likeReply,
  reply,
  quote,
  repost;

  String get iconAsset {
    return switch (this) {
      NotificationsType.follow => Assets.svg.iconSearchFollow,
      NotificationsType.like => Assets.svg.iconVideoLikeOff,
      NotificationsType.reply => Assets.svg.iconBlockComment,
      NotificationsType.likeReply => Assets.svg.iconBlockLikecomment,
      NotificationsType.quote => Assets.svg.iconFeedQuote,
      NotificationsType.repost => Assets.svg.iconFeedRepost,
    };
  }

  Color getBackgroundColor(BuildContext context) => switch (this) {
        NotificationsType.follow => context.theme.appColors.primaryAccent,
        NotificationsType.like => context.theme.appColors.attentionRed,
        NotificationsType.reply => context.theme.appColors.purple,
        NotificationsType.likeReply => context.theme.appColors.orangePeel,
        NotificationsType.quote => const Color(0xFF4340FF),
        NotificationsType.repost => const Color(0xFFA640FF),
      };

  String getDescription(
    BuildContext context,
    List<String> pubkeys,
  ) {
    switch (this) {
      case NotificationsType.follow:
        if (pubkeys.length == 1) {
          return context.i18n.notifications_followed_one;
        }
        if (pubkeys.length == 2) {
          return context.i18n.notifications_followed_two;
        }
        return context.i18n.notifications_followed_many(pubkeys.length - 1);
      case NotificationsType.like:
        if (pubkeys.length == 1) {
          return context.i18n.notifications_liked_one;
        }
        if (pubkeys.length == 2) {
          return context.i18n.notifications_liked_two;
        }
        return context.i18n.notifications_liked_many(pubkeys.length - 1);
      case NotificationsType.reply:
        return context.i18n.notifications_reply;
      case NotificationsType.likeReply:
        if (pubkeys.length == 1) {
          return context.i18n.notifications_liked_reply_one;
        }
        if (pubkeys.length == 2) {
          return context.i18n.notifications_liked_reply_two;
        }
        return context.i18n.notifications_liked_reply_many(pubkeys.length - 1);
      case NotificationsType.quote:
        return context.i18n.notifications_share;
      case NotificationsType.repost:
        return context.i18n.notifications_repost;
    }
  }
}
