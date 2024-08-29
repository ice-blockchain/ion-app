import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/overlay_menu/overlay_menu.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/feed/model/feed_category.dart';
import 'package:ice/app/features/feed/model/feed_filter.dart';
import 'package:ice/app/features/feed/providers/feed_current_filter_provider.dart';
import 'package:ice/app/features/feed/views/pages/feed_page/components/feed_controls/components/feed_filters/feed_filters_menu_overlay.dart';
import 'package:ice/generated/assets.gen.dart';

class FeedFiltersMenuButton extends StatelessWidget {
  const FeedFiltersMenuButton({super.key});

  @override
  Widget build(BuildContext context) {
    return OverlayMenu(
      offset: Offset(-160.0.s, 10.0.s),
      menuBuilder: (closeMenu) => FeedFiltersMenuOverlay(closeMenu: closeMenu),
      child: _MenuButton(),
    );
  }
}

class _MenuButton extends ConsumerWidget {
  const _MenuButton();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentFilter = ref.watch(feedCurrentFilterProvider);

    final icon = switch (currentFilter) {
      FeedFiltersState(category: FeedCategory.feed, filter: FeedFilter.forYou) =>
        Assets.images.icons.iconFeedForyou,
      FeedFiltersState(category: FeedCategory.feed, filter: FeedFilter.following) =>
        Assets.images.icons.iconFeedFollowing,
      FeedFiltersState(category: FeedCategory.articles, filter: FeedFilter.forYou) =>
        Assets.images.icons.iconArticleForyou,
      FeedFiltersState(category: FeedCategory.articles, filter: FeedFilter.following) =>
        Assets.images.icons.iconArticleFollowing,
      FeedFiltersState(category: FeedCategory.videos, filter: FeedFilter.forYou) =>
        Assets.images.icons.iconVideoForyou,
      FeedFiltersState(category: FeedCategory.videos, filter: FeedFilter.following) =>
        Assets.images.icons.iconVideoFollowing,
    };

    // We need this transform to draw the icon outside of the parent's size
    return Transform(
      transform: Matrix4.identity()..scale(1.075),
      child: icon.icon(size: 40.0.s),
    );
  }
}
