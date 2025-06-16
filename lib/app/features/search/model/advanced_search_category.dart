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
      AdvancedSearchCategory.all => Assets.svgIconTabAll,
      AdvancedSearchCategory.trending => Assets.svgIconmemeTranding,
      AdvancedSearchCategory.top => Assets.svgIconSearchTop,
      AdvancedSearchCategory.latest => Assets.svgIconSearchLast,
      AdvancedSearchCategory.people => Assets.svgIconSendfundsUser,
      AdvancedSearchCategory.photos => Assets.svgIconGalleryOpen,
      AdvancedSearchCategory.videos => Assets.svgIconVideosTrading,
      AdvancedSearchCategory.chat => Assets.svgIconChatOff,
      AdvancedSearchCategory.groups => Assets.svgIconSearchGroups,
      AdvancedSearchCategory.channels => Assets.svgIconSearchChannel,
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
      AdvancedSearchCategory.chat => context.i18n.chat_messages_title,
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
