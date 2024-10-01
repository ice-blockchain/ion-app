// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/overlay_menu/overlay_menu.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/feed/providers/feed_current_filter_provider.dart';
import 'package:ice/app/features/feed/views/pages/feed_page/components/feed_controls/components/feed_filters/feed_filters_menu_overlay.dart';

class FeedFiltersMenuButton extends StatelessWidget {
  const FeedFiltersMenuButton({super.key});

  @override
  Widget build(BuildContext context) {
    return OverlayMenu(
      offset: Offset(-160.0.s, 10.0.s),
      menuBuilder: (closeMenu) => FeedFiltersMenuOverlay(closeMenu: closeMenu),
      child: const _MenuButton(),
    );
  }
}

class _MenuButton extends ConsumerWidget {
  const _MenuButton();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.theme.appColors;

    final currentFilter = ref.watch(feedCurrentFilterProvider);

    final bigIcon = currentFilter.category.getIcon(context);
    final smallIcon = currentFilter.filter.getIcon(
      context,
      size: 12.0.s,
      color: colors.secondaryBackground,
    );

    return Stack(
      children: [
        SizedBox.square(
          dimension: 40.0.s,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: currentFilter.category.getColor(context),
              borderRadius: BorderRadius.circular(16.0.s),
            ),
            child: Center(child: bigIcon),
          ),
        ),
        Positioned(
          right: 0,
          bottom: 0,
          child: Transform.translate(
            offset: Offset(3.0.s, 3.0.s),
            child: SizedBox.square(
              dimension: 18.0.s,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: currentFilter.category.getColor(context),
                  borderRadius: BorderRadius.circular(20.0.s),
                  border: Border.all(
                    color: colors.secondaryBackground,
                    width: 1.0.s,
                  ),
                ),
                child: Center(child: smallIcon),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
