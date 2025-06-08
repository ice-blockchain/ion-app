// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/widgets.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/ion_connect/data/models/event_reference.c.dart';
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
  String getDescription(BuildContext context, [String eventTypeLabel = '']) {
    return switch (type) {
      CommentIonNotificationType.reply => context.i18n.notifications_reply(eventTypeLabel),
      CommentIonNotificationType.quote => context.i18n.notifications_share(eventTypeLabel),
      CommentIonNotificationType.repost => context.i18n.notifications_repost(eventTypeLabel),
    };
  }
}

final class LikesIonNotification extends IonNotification {
  LikesIonNotification({
    required this.eventReference,
    required this.total,
    required super.timestamp,
    required super.pubkeys,
  });

  final EventReference eventReference;

  final int total;

  @override
  String get asset => Assets.svg.iconVideoLikeOff;

  @override
  Color getBackgroundColor(BuildContext context) => context.theme.appColors.attentionRed;

  @override
  String getDescription(BuildContext context, [String eventTypeLabel = '']) {
    return switch (pubkeys.length) {
      1 => context.i18n.notifications_liked_one(eventTypeLabel),
      2 => context.i18n.notifications_liked_two(eventTypeLabel),
      _ => context.i18n.notifications_liked_many(total - 1, eventTypeLabel),
    };
  }
}

final class FollowersIonNotification extends IonNotification {
  FollowersIonNotification({
    required this.total,
    required super.timestamp,
    required super.pubkeys,
  });

  final int total;

  @override
  String get asset => Assets.svg.iconSearchFollow;

  @override
  Color getBackgroundColor(BuildContext context) => context.theme.appColors.primaryAccent;

  @override
  String getDescription(BuildContext context) {
    return switch (pubkeys.length) {
      1 => context.i18n.notifications_followed_one,
      2 => context.i18n.notifications_followed_two,
      _ => context.i18n.notifications_followed_many(total - 1)
    };
  }
}
