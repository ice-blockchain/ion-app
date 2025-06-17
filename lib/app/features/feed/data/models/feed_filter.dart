// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/widgets.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/generated/assets.gen.dart';

enum FeedFilter {
  forYou,
  following;

  Widget getIcon(BuildContext context, {double? size, Color? color}) {
    final defaultColor = context.theme.appColors.primaryText;

    final icon = switch (this) {
      FeedFilter.forYou => Assets.svgIconCategoriesForyou,
      FeedFilter.following => Assets.svgIconCategoriesFollowing,
    };

    return IconAssetColored(
      icon,
      color: color ?? defaultColor,
      size: size ?? 18.0,
    );
  }

  String getLabel(BuildContext context) => switch (this) {
        FeedFilter.forYou => context.i18n.feed_for_you,
        FeedFilter.following => context.i18n.feed_following,
      };
}
