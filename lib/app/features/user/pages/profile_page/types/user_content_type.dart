// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/generated/assets.gen.dart';

enum UserContentType {
  posts,
  replies,
  videos,
  articles;

  String get iconAsset {
    return switch (this) {
      UserContentType.posts => Assets.svg.iconProfileFeed,
      UserContentType.replies => Assets.svg.iconFeedReplies,
      UserContentType.videos => Assets.svg.iconFeedVideos,
      UserContentType.articles => Assets.svg.iconFeedArticles,
    };
  }

  String getTitle(BuildContext context) {
    switch (this) {
      case UserContentType.posts:
        return context.i18n.profile_posts;
      case UserContentType.replies:
        return context.i18n.profile_replies;
      case UserContentType.videos:
        return context.i18n.profile_videos;
      case UserContentType.articles:
        return context.i18n.profile_articles;
    }
  }
}
