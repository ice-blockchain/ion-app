// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/widgets.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/generated/assets.gen.dart';

enum ChannelDetailTab {
  posts,
  photos,
  videos,
  links;

  String getEmptyStateTitleForCurrentUser(BuildContext context) {
    final locale = context.i18n;
    return switch (this) {
      ChannelDetailTab.posts => locale.profile_posts_empty_list_current_user,
      ChannelDetailTab.photos => locale.profile_replies_empty_list_current_user,
      ChannelDetailTab.videos => locale.profile_videos_empty_list_current_user,
      ChannelDetailTab.links => locale.profile_articles_empty_list_current_user,
    };
  }

  String getEmptyStateTitle(BuildContext context, String username) {
    final locale = context.i18n;
    return switch (this) {
      ChannelDetailTab.posts => locale.profile_posts_empty_list(username),
      ChannelDetailTab.photos => locale.profile_replies_empty_list(username),
      ChannelDetailTab.videos => locale.profile_videos_empty_list(username),
      ChannelDetailTab.links => locale.profile_articles_empty_list(username),
    };
  }

  String get emptyStateIconAsset => switch (this) {
        ChannelDetailTab.posts => Assets.svgWalletIconProfileEmptyposts,
        ChannelDetailTab.photos => Assets.svgWalletIconProfileEmptyreplies,
        ChannelDetailTab.videos => Assets.svgWalletIconProfileEmptyvideo,
        ChannelDetailTab.links => Assets.svgWalletIconProfileEmptyarticles,
      };

  String getTitle(BuildContext context) {
    switch (this) {
      case ChannelDetailTab.posts:
        return context.i18n.profile_posts;
      case ChannelDetailTab.photos:
        return context.i18n.common_photos;
      case ChannelDetailTab.videos:
        return context.i18n.profile_videos;
      case ChannelDetailTab.links:
        return context.i18n.common_links;
    }
  }

  String get iconAsset => switch (this) {
        ChannelDetailTab.posts => Assets.svgIconProfileFeed,
        ChannelDetailTab.photos => Assets.svgIconGalleryOpen,
        ChannelDetailTab.videos => Assets.svgIconFeedVideos,
        ChannelDetailTab.links => Assets.svgIconArticleLink,
      };
}
