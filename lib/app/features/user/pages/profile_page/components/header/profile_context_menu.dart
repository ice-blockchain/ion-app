// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/overlay_menu/overlay_menu.dart';
import 'package:ion/app/components/overlay_menu/overlay_menu_container.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.m.dart';
import 'package:ion/app/features/user/pages/components/header_action/header_action.dart';
import 'package:ion/app/features/user/pages/profile_page/components/header/context_menu_item.dart';
import 'package:ion/app/features/user/pages/profile_page/components/header/context_menu_item_divider.dart';
import 'package:ion/app/features/user/pages/profile_page/providers/profile_context_menu_provider.r.dart';
import 'package:ion/app/features/user/providers/report_notifier.m.dart';
import 'package:ion/app/features/user_block/providers/block_list_notifier.r.dart';
import 'package:ion/generated/assets.gen.dart';

class ProfileContextMenu extends ConsumerWidget {
  const ProfileContextMenu({
    required this.pubkey,
    super.key,
  });

  final String pubkey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.displayErrors(reportNotifierProvider);

    return OverlayMenu(
      menuBuilder: (closeMenu) {
        final menuItems = _buildMenuItems(
          context,
          ref,
          closeMenu,
        );

        return OverlayMenuContainer(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: menuItems,
          ),
        );
      },
      child: HeaderAction(
        onPressed: () {},
        disabled: true,
        opacity: 1,
        assetName: Assets.svg.iconMorePopup,
      ),
    );
  }

  List<Widget> _buildMenuItems(
    BuildContext context,
    WidgetRef ref,
    VoidCallback closeMenu,
  ) {
    final controller = ref.read(profileContextMenuControllerProvider);
    final isCurrentUser = ref.watch(isCurrentUserSelectorProvider(pubkey));

    if (isCurrentUser) {
      return [
        ContextMenuItem(
          label: context.i18n.button_share,
          iconAsset: Assets.svg.iconButtonShare,
          onPressed: () {
            closeMenu();
            controller.shareProfile(context, pubkey);
          },
        ),
        const ContextMenuItemDivider(),
        ContextMenuItem(
          label: context.i18n.bookmarks_title,
          iconAsset: Assets.svg.iconBookmarks,
          onPressed: () {
            closeMenu();
            controller.viewBookmarks(context);
          },
        ),
        const ContextMenuItemDivider(),
        ContextMenuItem(
          label: context.i18n.settings_title,
          iconAsset: Assets.svg.iconProfileSettings,
          onPressed: () {
            closeMenu();
            controller.openSettings(context);
          },
        ),
      ];
    } else {
      return [
        ContextMenuItem(
          label: context.i18n.button_share,
          iconAsset: Assets.svg.iconButtonShare,
          onPressed: () {
            closeMenu();
            controller.shareProfile(context, pubkey);
          },
        ),
        const ContextMenuItemDivider(),
        _BlockUserMenuItem(masterPubkey: pubkey, closeMenu: closeMenu),
        const ContextMenuItemDivider(),
        ContextMenuItem(
          label: context.i18n.button_report,
          iconAsset: Assets.svg.iconReport,
          onPressed: () {
            closeMenu();
            controller.reportUser(pubkey);
          },
        ),
      ];
    }
  }
}

class _BlockUserMenuItem extends ConsumerWidget {
  const _BlockUserMenuItem({
    required this.masterPubkey,
    required this.closeMenu,
  });

  final String masterPubkey;
  final VoidCallback closeMenu;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(profileContextMenuControllerProvider);
    final isBlocked = ref.watch(isBlockedNotifierProvider(masterPubkey)).valueOrNull ?? false;

    return ContextMenuItem(
      label: isBlocked ? context.i18n.button_unblock : context.i18n.button_block,
      iconAsset: Assets.svg.iconBlockClose3,
      onPressed: () {
        closeMenu();
        controller.handleBlockUser(context, masterPubkey: masterPubkey, isBlocked: isBlocked);
      },
    );
  }
}
