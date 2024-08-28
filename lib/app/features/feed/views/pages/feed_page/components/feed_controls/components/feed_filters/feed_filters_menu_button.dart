import 'package:flutter/material.dart';
import 'package:ice/app/components/overlay_menu/overlay_menu.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/feed/views/pages/feed_page/components/feed_controls/components/feed_filters/feed_filters_menu_overlay.dart';
import 'package:ice/app/router/components/navigation_button/navigation_button.dart';
import 'package:ice/generated/assets.gen.dart';

class FeedFiltersMenuButton extends StatelessWidget {
  const FeedFiltersMenuButton({super.key});

  @override
  Widget build(BuildContext context) {
    return OverlayMenu(
      offset: Offset(-160.0.s, 10.0.s),
      menuBuilder: (closeMenu) => FeedFiltersMenuOverlay(closeMenu: closeMenu),
      child: NavigationButton(
        icon: Assets.images.icons.iconHeaderMenu.icon(
          color: context.theme.appColors.primaryText,
        ),
      ),
    );
  }
}
