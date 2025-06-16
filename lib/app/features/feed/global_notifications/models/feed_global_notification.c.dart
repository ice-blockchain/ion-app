// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/widgets.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/components/global_notification_bar/components/global_notification_view.dart';
import 'package:ion/app/components/global_notification_bar/models/global_notification.dart';
import 'package:ion/app/components/progress_bar/ion_loading_indicator.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/generated/assets.gen.dart';

part 'feed_global_notification.c.freezed.dart';

@freezed
class FeedGlobalNotification with _$FeedGlobalNotification implements GlobalNotification {
  factory FeedGlobalNotification({
    required FeedNotificationStatus status,
    required FeedNotificationContentType type,
  }) = _FeedGlobalNotification;

  const FeedGlobalNotification._();

  @override
  Widget buildWidget(BuildContext context) {
    return GlobalNotificationView(
      message: type.getMessage(context, status),
      backgroundColor: status.getBackgroundColor(context),
      icon: status.getIcon(context),
    );
  }
}

enum FeedNotificationStatus {
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
        published => Assets.svgIconBlockCheckboxOn.icon(),
        success => null,
      };
}

enum FeedNotificationContentType {
  video,
  story,
  post,
  article,
  reply,
  repost,
  modify,
  delete;

  FeedGlobalNotification loading() => FeedGlobalNotification(
        status: FeedNotificationStatus.loading,
        type: this,
      );

  FeedGlobalNotification ready() => FeedGlobalNotification(
        status: this == FeedNotificationContentType.repost
            ? FeedNotificationStatus.success
            : FeedNotificationStatus.published,
        type: this,
      );

  String getMessage(BuildContext context, FeedNotificationStatus state) {
    final locale = context.i18n;
    return switch (state) {
      FeedNotificationStatus.loading => switch (this) {
          video => locale.notification_video_loading,
          story => locale.notification_story_loading,
          post => locale.notification_post_loading,
          article => locale.notification_article_loading,
          reply => locale.notification_reply_loading,
          repost => locale.notification_repost_loading,
          modify => locale.notification_modify_loading,
          delete => locale.notification_delete_loading,
        },
      FeedNotificationStatus.published => switch (this) {
          video => locale.notification_video_published,
          story => locale.notification_story_published,
          post => locale.notification_post_published,
          article => locale.notification_article_published,
          reply => locale.notification_reply_published,
          modify => locale.notification_modify_published,
          delete => locale.notification_delete_published,
          repost => throw ArgumentError('No published state for $this'),
        },
      FeedNotificationStatus.success => switch (this) {
          repost => locale.notification_repost_successful,
          _ => throw ArgumentError('No success state for $this'),
        },
    };
  }
}
