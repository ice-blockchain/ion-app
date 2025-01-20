// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/extensions/build_context.dart';
import 'package:ion/app/extensions/theme_data.dart';
import 'package:ion/app/router/model/main_modal_list_item.dart';
import 'package:ion/generated/assets.gen.dart';

enum FeedType implements MainModalListItem {
  post,
  story,
  video,
  article;

  @override
  String getDisplayName(BuildContext context) {
    return switch (this) {
      FeedType.post => context.i18n.feed_modal_post,
      FeedType.story => context.i18n.feed_modal_story,
      FeedType.video => context.i18n.feed_modal_video,
      FeedType.article => context.i18n.feed_modal_article,
    };
  }

  @override
  String getDescription(BuildContext context) {
    return switch (this) {
      FeedType.post => context.i18n.feed_modal_post_description,
      FeedType.story => context.i18n.feed_modal_story_description,
      FeedType.video => context.i18n.feed_modal_video_description,
      FeedType.article => context.i18n.feed_modal_article_description,
    };
  }

  @override
  Color getIconColor(BuildContext context) {
    return switch (this) {
      FeedType.post => context.theme.appColors.purple,
      FeedType.story => context.theme.appColors.orangePeel,
      FeedType.video => context.theme.appColors.raspberry,
      FeedType.article => context.theme.appColors.success,
    };
  }

  @override
  String get iconAsset {
    return switch (this) {
      FeedType.post => Assets.svg.iconFeedPost,
      FeedType.story => Assets.svg.iconFeedStories,
      FeedType.video => Assets.svg.iconVideosTrading,
      FeedType.article => Assets.svg.iconFeedArticles,
    };
  }
}
