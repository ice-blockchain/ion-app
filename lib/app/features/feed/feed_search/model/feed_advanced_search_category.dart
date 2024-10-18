// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/widgets.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/generated/assets.gen.dart';

enum FeedAdvancedSearchCategory {
  top,
  latest,
  people,
  photos,
  videos,
  groups,
  channels;

  String icon(BuildContext context) {
    return switch (this) {
      FeedAdvancedSearchCategory.top => Assets.svg.iconSearchTop,
      FeedAdvancedSearchCategory.latest => Assets.svg.iconSearchLast,
      FeedAdvancedSearchCategory.people => Assets.svg.iconSendfundsUser,
      FeedAdvancedSearchCategory.photos => Assets.svg.iconGalleryOpen,
      FeedAdvancedSearchCategory.videos => Assets.svg.iconVideosTrading,
      FeedAdvancedSearchCategory.groups => Assets.svg.iconSearchGroups,
      FeedAdvancedSearchCategory.channels => Assets.svg.iconSearchChannel,
    };
  }

  String label(BuildContext context) {
    return switch (this) {
      FeedAdvancedSearchCategory.top => context.i18n.feed_advanced_search_category_top,
      FeedAdvancedSearchCategory.latest => context.i18n.feed_advanced_search_category_latest,
      FeedAdvancedSearchCategory.people => context.i18n.feed_advanced_search_category_people,
      FeedAdvancedSearchCategory.photos => context.i18n.feed_advanced_search_category_photos,
      FeedAdvancedSearchCategory.videos => context.i18n.feed_advanced_search_category_videos,
      FeedAdvancedSearchCategory.groups => context.i18n.feed_advanced_search_category_groups,
      FeedAdvancedSearchCategory.channels => context.i18n.feed_advanced_search_category_channels,
    };
  }
}
