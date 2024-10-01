// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/widgets.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/generated/assets.gen.dart';

enum FeedFilter {
  forYou,
  following;

  Widget getIcon(BuildContext context, {double? size, Color? color}) {
    final defaultColor = context.theme.appColors.primaryText;

    final icon = switch (this) {
      FeedFilter.forYou => Assets.svg.iconCategoriesForyou,
      FeedFilter.following => Assets.svg.iconCategoriesFollowing,
    };

    return icon.icon(
      color: color ?? defaultColor,
      size: size ?? 18.0.s,
    );
  }

  String getLabel(BuildContext context) => switch (this) {
        FeedFilter.forYou => context.i18n.feed_for_you,
        FeedFilter.following => context.i18n.feed_following,
      };
}
