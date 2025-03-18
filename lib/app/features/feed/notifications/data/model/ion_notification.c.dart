// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/widgets.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';
import 'package:ion/generated/assets.gen.dart';

sealed class IonNotification {
  IonNotification({required this.timestamp, required this.pubkeys});

  final DateTime timestamp;

  final List<String> pubkeys;

  String get asset;

  String getDescription(BuildContext context);

  Color getBackgroundColor(BuildContext context);
}

enum CommentIonNotificationType { reply, quote, repost }

final class CommentIonNotification extends IonNotification {
  CommentIonNotification({
    required this.type,
    required this.eventReference,
    required super.timestamp,
  }) : super(pubkeys: [eventReference.pubkey]);

  final CommentIonNotificationType type;

  final EventReference eventReference;

  @override
  String get asset => switch (type) {
        CommentIonNotificationType.reply => Assets.svg.iconBlockComment,
        CommentIonNotificationType.quote => Assets.svg.iconFeedQuote,
        CommentIonNotificationType.repost => Assets.svg.iconFeedRepost
      };

  @override
  Color getBackgroundColor(BuildContext context) {
    return switch (type) {
      CommentIonNotificationType.reply => context.theme.appColors.purple,
      CommentIonNotificationType.quote => context.theme.appColors.medBlue,
      CommentIonNotificationType.repost => context.theme.appColors.pink,
    };
  }

  @override
  String getDescription(BuildContext context) {
    return switch (type) {
      CommentIonNotificationType.reply => context.i18n.notifications_reply,
      CommentIonNotificationType.quote => context.i18n.notifications_share,
      CommentIonNotificationType.repost => context.i18n.notifications_repost
    };
  }
}

//TODO:add total
final class LikesIonNotification extends IonNotification {
  LikesIonNotification({
    required this.eventReference,
    required super.timestamp,
    required super.pubkeys,
  });

  final EventReference eventReference;

  @override
  String get asset => Assets.svg.iconVideoLikeOff;

  @override
  Color getBackgroundColor(BuildContext context) => context.theme.appColors.attentionRed;

  @override
  String getDescription(BuildContext context) {
    if (pubkeys.length == 1) {
      return context.i18n.notifications_liked_one;
    }
    if (pubkeys.length == 2) {
      return context.i18n.notifications_liked_two;
    }
    return context.i18n.notifications_liked_many(pubkeys.length - 1);
  }
}

final class FollowersIonNotification extends IonNotification {
  FollowersIonNotification({
    required super.timestamp,
    required super.pubkeys,
  });

  @override
  String get asset => Assets.svg.iconSearchFollow;

  @override
  Color getBackgroundColor(BuildContext context) => context.theme.appColors.primaryAccent;

  @override
  String getDescription(BuildContext context) {
    if (pubkeys.length == 1) {
      return context.i18n.notifications_followed_one;
    }
    if (pubkeys.length == 2) {
      return context.i18n.notifications_followed_two;
    }
    return context.i18n.notifications_followed_many(pubkeys.length - 1);
  }
}
