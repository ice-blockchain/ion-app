// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/widgets.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';
import 'package:ion/generated/assets.gen.dart';

// part 'ion_connect_notification.c.freezed.dart';

// @freezed
// class IonConnectNotification with _$IonConnectNotification {
//   const factory IonConnectNotification({
//     required NotificationsType type,
//     required List<String> pubkeys,
//     required DateTime timestamp,
//     EventReference? eventReference,
//   }) = _IonConnectNotification;
// }

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
