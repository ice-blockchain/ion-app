// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/components/progress_bar/ion_loading_indicator.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/generated/assets.gen.dart';

class GlobalNotificationData {
  const GlobalNotificationData({
    required this.status,
    required this.type,
  });

  final NotificationStatus status;
  final NotificationContentType type;

  Widget? getIcon(BuildContext context) => status.getIcon(context);
  String getMessage(BuildContext context) => type.getMessage(context, status);
  Color getBackgroundColor(BuildContext context) => status.getBackgroundColor(context);
}

enum NotificationStatus {
  loading,
  published,
  success;

  Color getBackgroundColor(BuildContext context) => switch (this) {
        loading => context.theme.appColors.orangePeel,
        published => context.theme.appColors.primaryAccent,
        success => context.theme.appColors.success,
      };

  Widget? getIcon(BuildContext context) => switch (this) {
        loading => IONLoadingIndicator(size: Size.square(16.0.s)),
        published => Assets.svg.iconBlockCheckboxOnblue.icon(
            color: context.theme.appColors.success,
          ),
        success => null,
      };
}

enum NotificationContentType {
  video,
  story,
  post,
  article,
  reply,
  repost;

  GlobalNotificationData loading() => GlobalNotificationData(
        status: NotificationStatus.loading,
        type: this,
      );

  GlobalNotificationData ready() =>
      this == NotificationContentType.reply || this == NotificationContentType.repost
          ? GlobalNotificationData(
              status: NotificationStatus.success,
              type: this,
            )
          : GlobalNotificationData(
              status: NotificationStatus.published,
              type: this,
            );

  String getMessage(BuildContext context, NotificationStatus state) {
    final locale = context.i18n;
    return switch (state) {
      NotificationStatus.loading => switch (this) {
          video => locale.notification_video_loading,
          story => locale.notification_story_loading,
          post => locale.notification_post_loading,
          article => locale.notification_article_loading,
          _ => throw ArgumentError('No loading state for $this'),
        },
      NotificationStatus.published => switch (this) {
          video => locale.notification_video_published,
          story => locale.notification_story_published,
          post => locale.notification_post_published,
          article => locale.notification_article_published,
          _ => throw ArgumentError('No published state for $this'),
        },
      NotificationStatus.success => switch (this) {
          reply => locale.notification_reply_sent,
          repost => locale.notification_repost_successful,
          _ => throw ArgumentError('No success state for $this'),
        },
    };
  }
}
