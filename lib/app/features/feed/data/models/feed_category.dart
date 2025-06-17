// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/widgets.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/extensions/asset_gen_image.dart';
import 'package:ion/app/extensions/build_context.dart';
import 'package:ion/app/extensions/theme_data.dart';
import 'package:ion/generated/assets.gen.dart';

enum FeedCategory {
  @JsonValue('feed')
  feed,

  @JsonValue('videos')
  videos,

  @JsonValue('articles')
  articles;

  String getLabel(BuildContext context) => switch (this) {
        FeedCategory.feed => context.i18n.general_feed,
        FeedCategory.videos => context.i18n.general_videos,
        FeedCategory.articles => context.i18n.general_articles,
      };

  Color getColor(BuildContext context) => switch (this) {
        FeedCategory.feed => context.theme.appColors.purple,
        FeedCategory.videos => context.theme.appColors.raspberry,
        FeedCategory.articles => context.theme.appColors.success,
      };

  Widget getIcon(BuildContext context, {Color? color}) {
    final defaultColor = context.theme.appColors.secondaryBackground;

    final icon = switch (this) {
      FeedCategory.feed => Assets.svgIconProfileFeed,
      FeedCategory.videos => Assets.svgIconVideosTrading,
      FeedCategory.articles => Assets.svgIconFeedArticles,
    };

    return IconAssetColored(icon, color: color ?? defaultColor);
  }

  String getPostsNames(BuildContext context) => switch (this) {
        FeedCategory.feed => context.i18n.profile_posts.toLowerCase(),
        FeedCategory.videos => context.i18n.profile_videos.toLowerCase(),
        FeedCategory.articles => context.i18n.profile_articles.toLowerCase(),
      };
}
