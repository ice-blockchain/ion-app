import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/button/button.dart';
import 'package:ice/app/components/overlay_menu/overlay_menu_container.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/feed/model/feed_category.dart';
import 'package:ice/app/features/feed/model/feed_filter.dart';
import 'package:ice/app/features/feed/providers/feed_current_category_provider.dart';
import 'package:ice/app/features/feed/providers/feed_current_filter_provider.dart';
import 'package:ice/app/features/feed/views/pages/feed_page/components/feed_controls/components/feed_filters/feed_filters_menu_item.dart';

class FeedFiltersMenuOverlay extends StatelessWidget {
  const FeedFiltersMenuOverlay({
    super.key,
    required this.closeMenu,
  });

  final VoidCallback closeMenu;

  @override
  Widget build(BuildContext context) {
    final colors = context.theme.appColors;

    return OverlayMenuContainer(
      child: SizedBox(
        width: 200.0.s,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 16.0.s),
            ...<Widget>[
              for (final category in FeedCategory.values)
                _FeedCategoryItem(
                  category: category,
                  closeMenu: closeMenu,
                ),
            ].intersperse(SizedBox(height: 10.0.s)).toList(),
            SizedBox(height: 10.0.s),
            Divider(
              color: colors.attentionBlock,
              height: 0.5.s,
              thickness: 0.5.s,
            ),
            SizedBox(height: 10.0.s),
            ...<Widget>[
              for (final filter in FeedFilter.values)
                _FeedFilterItem(
                  filter: filter,
                  closeMenu: closeMenu,
                ),
            ].intersperse(SizedBox(height: 10.0.s)).toList(),
            SizedBox(height: 16.0.s),
          ],
        ),
      ),
    );
  }
}

class _FeedCategoryItem extends ConsumerWidget {
  const _FeedCategoryItem({
    required this.category,
    required this.closeMenu,
  });

  final FeedCategory category;
  final VoidCallback closeMenu;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentCategory = ref.watch(feedCurrentCategoryProvider);
    final isSelected = currentCategory == category;

    return FeedFiltersMenuItem(
      onPressed: () {
        ref.read(feedCurrentCategoryProvider.notifier).category = category;
        closeMenu();
      },
      isSelected: isSelected,
      icon: ButtonIconFrame(
        color: category.getColor(context),
        icon: category.getIcon(context),
      ),
      label: category.getLabel(context),
    );
  }
}

class _FeedFilterItem extends ConsumerWidget {
  const _FeedFilterItem({
    required this.filter,
    required this.closeMenu,
  });

  final FeedFilter filter;
  final VoidCallback closeMenu;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.theme.appColors;
    final currentFilter = ref.watch(feedCurrentFilterProvider);
    final isSelected = currentFilter == filter;

    return FeedFiltersMenuItem(
      onPressed: () {
        ref.read(feedCurrentFilterProvider.notifier).filter = filter;
        closeMenu();
      },
      isSelected: isSelected,
      icon: ButtonIconFrame(
        color: colors.tertararyBackground,
        border: Border.all(color: colors.onTerararyFill),
        icon: filter.getIcon(context),
      ),
      label: filter.getLabel(context),
    );
  }
}
