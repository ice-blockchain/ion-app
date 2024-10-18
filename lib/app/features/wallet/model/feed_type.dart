// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/extensions/build_context.dart';
import 'package:ion/app/extensions/theme_data.dart';
import 'package:ion/generated/assets.gen.dart';

enum FeedType {
  post,
  story,
  video,
  article;

  String getDisplayName(BuildContext context) {
    return switch (this) {
      FeedType.post => context.i18n.feed_modal_post,
      FeedType.story => context.i18n.feed_modal_story,
      FeedType.video => context.i18n.feed_modal_video,
      FeedType.article => context.i18n.feed_modal_article,
    };
  }

  String getDescription(BuildContext context) {
    return switch (this) {
      FeedType.post => context.i18n.feed_modal_post_description,
      FeedType.story => context.i18n.feed_modal_story_description,
      FeedType.video => context.i18n.feed_modal_video_description,
      FeedType.article => context.i18n.feed_modal_article_description,
    };
  }

  Color getIconColor(BuildContext context) {
    return switch (this) {
      FeedType.post => context.theme.appColors.purple,
      FeedType.story => context.theme.appColors.orangePeel,
      FeedType.video => context.theme.appColors.raspberry,
      FeedType.article => context.theme.appColors.success,
    };
  }

  String get iconAsset {
    return switch (this) {
      FeedType.post => Assets.svg.iconFeedPost,
      FeedType.story => Assets.svg.iconFeedStory,
      FeedType.video => Assets.svg.iconVideosTrading,
      FeedType.article => Assets.svg.iconFeedStories,
    };
  }
}
