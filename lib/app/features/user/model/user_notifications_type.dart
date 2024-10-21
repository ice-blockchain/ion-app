// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/extensions/build_context.dart';
import 'package:ion/generated/assets.gen.dart';

enum UserNotificationsType {
  none,
  stories,
  posts,
  videos,
  articles;

  String get iconAsset {
    return switch (this) {
      UserNotificationsType.none => Assets.svg.iconProfileNotificationMute,
      UserNotificationsType.stories => Assets.svg.iconFeedStories,
      UserNotificationsType.posts => Assets.svg.iconFeedPost,
      UserNotificationsType.videos => Assets.svg.iconFeedVideos,
      UserNotificationsType.articles => Assets.svg.iconFeedArticles,
    };
  }

  String getTitle(BuildContext context) {
    switch (this) {
      case UserNotificationsType.none:
        return context.i18n.profile_none;
      case UserNotificationsType.stories:
        return context.i18n.profile_stories;
      case UserNotificationsType.posts:
        return context.i18n.profile_posts;
      case UserNotificationsType.videos:
        return context.i18n.profile_videos;
      case UserNotificationsType.articles:
        return context.i18n.profile_articles;
    }
  }
}
