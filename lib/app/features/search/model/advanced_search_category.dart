// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/widgets.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/generated/assets.gen.dart';

enum AdvancedSearchCategory {
  all,
  trending,
  top,
  latest,
  people,
  photos,
  videos,
  chat,
  groups,
  channels;

  String icon(BuildContext context) {
    return switch (this) {
      AdvancedSearchCategory.all => Assets.svg.iconTabAll,
      AdvancedSearchCategory.trending => Assets.svg.iconmemeTranding,
      AdvancedSearchCategory.top => Assets.svg.iconSearchTop,
      AdvancedSearchCategory.latest => Assets.svg.iconSearchLast,
      AdvancedSearchCategory.people => Assets.svg.iconSendfundsUser,
      AdvancedSearchCategory.photos => Assets.svg.iconGalleryOpen,
      AdvancedSearchCategory.videos => Assets.svg.iconVideosTrading,
      AdvancedSearchCategory.chat => Assets.svg.iconChatOff,
      AdvancedSearchCategory.groups => Assets.svg.iconSearchGroups,
      AdvancedSearchCategory.channels => Assets.svg.iconSearchChannel,
    };
  }

  String label(BuildContext context) {
    return switch (this) {
      AdvancedSearchCategory.all => context.i18n.core_all,
      AdvancedSearchCategory.trending => context.i18n.feed_advanced_search_category_trending,
      AdvancedSearchCategory.top => context.i18n.feed_advanced_search_category_top,
      AdvancedSearchCategory.latest => context.i18n.feed_advanced_search_category_latest,
      AdvancedSearchCategory.people => context.i18n.feed_advanced_search_category_people,
      AdvancedSearchCategory.photos => context.i18n.feed_advanced_search_category_photos,
      AdvancedSearchCategory.videos => context.i18n.feed_advanced_search_category_videos,
      AdvancedSearchCategory.chat => context.i18n.chat_title,
      AdvancedSearchCategory.groups => context.i18n.feed_advanced_search_category_groups,
      AdvancedSearchCategory.channels => context.i18n.feed_advanced_search_category_channels,
    };
  }

  bool get isFeed {
    return switch (this) {
      AdvancedSearchCategory.trending => true,
      AdvancedSearchCategory.top => true,
      AdvancedSearchCategory.latest => true,
      AdvancedSearchCategory.people => true,
      AdvancedSearchCategory.photos => true,
      AdvancedSearchCategory.videos => true,
      _ => false,
    };
  }

  bool get isChat {
    return switch (this) {
      AdvancedSearchCategory.all => true,
      AdvancedSearchCategory.people => true,
      AdvancedSearchCategory.chat => true,
      AdvancedSearchCategory.groups => true,
      AdvancedSearchCategory.channels => true,
      _ => false,
    };
  }

  bool get isCommunity {
    return switch (this) {
      AdvancedSearchCategory.groups => true,
      AdvancedSearchCategory.channels => true,
      _ => false,
    };
  }
}
