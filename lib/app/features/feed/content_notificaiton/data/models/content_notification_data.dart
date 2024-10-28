// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/components/progress_bar/ion_loading_indicator.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/generated/assets.gen.dart';

part 'content_notification_data.freezed.dart';

@freezed
sealed class NotificationData with _$NotificationData {
  const factory NotificationData.loading(ContentType contentType) = _NotificationLoading;
  const factory NotificationData.published(ContentType contentType) = _NotificationPublished;
  const factory NotificationData.success(ContentType contentType) = _NotificationSuccess;
}

enum ContentType {
  video,
  story,
  post,
  article,
  reply,
  repost;
}

extension NotificationDataExtension on NotificationData {
  ContentType get contentType => when(
        loading: (contentType) => contentType,
        published: (contentType) => contentType,
        success: (contentType) => contentType,
      );

  Color getBackgroundColor(BuildContext context) {
    return when(
      loading: (_) => context.theme.appColors.orangePeel,
      published: (_) => context.theme.appColors.primaryAccent,
      success: (_) => context.theme.appColors.success,
    );
  }

  Widget getIcon(BuildContext context) {
    return when(
      loading: (_) => IonLoadingIndicator(
        size: Size.square(16.0.s),
      ),
      published: (_) => Assets.svg.iconBlockCheckboxOnblue.icon(
        color: context.theme.appColors.onPrimaryAccent,
      ),
      success: (_) => Assets.svg.iconBlockCheckboxOnblue.icon(
        color: context.theme.appColors.onPrimaryAccent,
      ),
    );
  }

  String getMessage(BuildContext context) {
    final locale = context.i18n;
    final contentType = this.contentType;

    return when(
      loading: (_) {
        return switch (contentType) {
          ContentType.video => locale.notification_video_loading,
          ContentType.story => locale.notification_story_loading,
          ContentType.post => locale.notification_post_loading,
          ContentType.article => locale.notification_article_loading,
          _ => throw ArgumentError('No loading state for $contentType'),
        };
      },
      published: (_) {
        return switch (contentType) {
          ContentType.video => locale.notification_video_published,
          ContentType.story => locale.notification_story_published,
          ContentType.post => locale.notification_post_published,
          ContentType.article => locale.notification_article_published,
          _ => throw ArgumentError('No published state for $contentType'),
        };
      },
      success: (_) {
        return switch (contentType) {
          ContentType.reply => locale.notification_reply_sent,
          ContentType.repost => locale.notification_repost_successful,
          _ => throw ArgumentError('No success state for $contentType')
        };
      },
    );
  }
}
