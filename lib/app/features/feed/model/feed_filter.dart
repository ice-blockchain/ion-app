import 'package:flutter/widgets.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/generated/assets.gen.dart';

enum FeedFilter {
  forYou,
  following;

  Widget getIcon(BuildContext context) {
    final color = context.theme.appColors.primaryText;
    return switch (this) {
      FeedFilter.forYou => Assets.images.icons.iconCategoriesForyou.icon(
          color: color,
          size: 18.0.s,
        ),
      FeedFilter.following => Assets.images.icons.iconCategoriesFollowing.icon(
          color: color,
          size: 18.0.s,
        ),
    };
  }

  String getLabel(BuildContext context) => switch (this) {
        FeedFilter.forYou => context.i18n.feed_for_you,
        FeedFilter.following => context.i18n.feed_following,
      };
}
