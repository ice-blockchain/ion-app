import 'package:flutter/widgets.dart';
import 'package:ice/app/extensions/asset_gen_image.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/generated/assets.gen.dart';

enum FeedCategory {
  feed,
  videos,
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
      FeedCategory.feed => Assets.svg.iconProfileFeed,
      FeedCategory.videos => Assets.svg.iconVideosTrading,
      FeedCategory.articles => Assets.svg.iconFeedStories,
    };

    return icon.icon(color: color ?? defaultColor);
  }
}
