// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/extensions/build_context.dart';
import 'package:ion/generated/assets.gen.dart';

enum UserContentType {
  posts,
  replies,
  videos,
  articles;

  String get iconAsset {
    return switch (this) {
      UserContentType.posts => Assets.svgIconProfileFeed,
      UserContentType.replies => Assets.svgIconFeedReplies,
      UserContentType.videos => Assets.svgIconFeedVideos,
      UserContentType.articles => Assets.svgIconFeedArticles,
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
