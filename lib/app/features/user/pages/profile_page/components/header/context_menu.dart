// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/overlay_menu/overlay_menu.dart';
import 'package:ice/app/components/overlay_menu/overlay_menu_container.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/user/pages/components/header_action/header_action.dart';
import 'package:ice/app/features/user/pages/profile_page/components/header/context_menu_item.dart';
import 'package:ice/app/features/user/pages/profile_page/components/header/context_menu_item_divider.dart';
import 'package:ice/generated/assets.gen.dart';

class ContextMenu extends HookConsumerWidget {
  const ContextMenu({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final menuWidth = useState<double>(100.0.s);

    final updateWidth = useCallback(
      (Size size) {
        if (size.width > menuWidth.value) {
          menuWidth.value = size.width;
        }
      },
      [],
    );

    return OverlayMenu(
      menuBuilder: (closeMenu) => Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            top: 6.0.s,
            left: -menuWidth.value + HeaderAction.buttonSize,
            child: OverlayMenuContainer(
              child: IntrinsicWidth(
                child: Column(
                  children: [
                    ContextMenuItem(
                      label: context.i18n.button_share,
                      iconAsset: Assets.svg.iconButtonShare,
                      onPressed: closeMenu,
                      onLayout: updateWidth,
                    ),
                    const ContextMenuItemDivider(),
                    ContextMenuItem(
                      label: context.i18n.button_mute,
                      iconAsset: Assets.svg.iconChannelMute,
                      onPressed: closeMenu,
                      onLayout: updateWidth,
                    ),
                    const ContextMenuItemDivider(),
                    ContextMenuItem(
                      label: context.i18n.button_block,
                      iconAsset: Assets.svg.iconBlockClose3,
                      onPressed: closeMenu,
                      onLayout: updateWidth,
                    ),
                    const ContextMenuItemDivider(),
                    ContextMenuItem(
                      label: context.i18n.button_report,
                      iconAsset: Assets.svg.iconReport,
                      onPressed: closeMenu,
                      onLayout: updateWidth,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      child: HeaderAction(
        onPressed: () {},
        disabled: true,
        assetName: Assets.svg.iconMorePopup,
      ),
    );
  }
}
