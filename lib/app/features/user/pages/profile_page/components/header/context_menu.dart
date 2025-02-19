// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/overlay_menu/overlay_menu.dart';
import 'package:ion/app/components/overlay_menu/overlay_menu_container.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/user/pages/components/header_action/header_action.dart';
import 'package:ion/app/features/user/pages/profile_page/components/header/context_menu_item.dart';
import 'package:ion/app/features/user/pages/profile_page/components/header/context_menu_item_divider.dart';
import 'package:ion/app/features/user/pages/profile_page/pages/block_user_modal/block_user_modal.dart';
import 'package:ion/app/features/user/pages/profile_page/pages/report_user_modal/report_user_modal.dart';
import 'package:ion/app/features/user/providers/block_list_notifier.c.dart';
import 'package:ion/app/router/utils/show_simple_bottom_sheet.dart';
import 'package:ion/generated/assets.gen.dart';

class ContextMenu extends HookConsumerWidget {
  const ContextMenu({
    required this.pubkey,
    this.opacity = 1,
    super.key,
  });

  final String pubkey;
  final double opacity;

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
      menuBuilder: (closeMenu) => OverlayMenuContainer(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ContextMenuItem(
              label: context.i18n.button_share,
              iconAsset: Assets.svg.iconButtonShare,
              onPressed: closeMenu,
              onLayout: updateWidth,
            ),
            const ContextMenuItemDivider(),
            _BlockUserMenuItem(
              pubkey: pubkey,
              onLayout: updateWidth,
              closeMenu: closeMenu,
            ),
            const ContextMenuItemDivider(),
            ContextMenuItem(
              label: context.i18n.button_report,
              iconAsset: Assets.svg.iconReport,
              onPressed: () {
                showSimpleBottomSheet<void>(
                  context: context,
                  child: ReportUserModal(
                    pubkey: pubkey,
                  ),
                );
              },
              onLayout: updateWidth,
            ),
          ],
        ),
      ),
      child: HeaderAction(
        onPressed: () {},
        disabled: true,
        opacity: opacity,
        assetName: Assets.svg.iconMorePopup,
      ),
    );
  }
}

class _BlockUserMenuItem extends ConsumerWidget {
  const _BlockUserMenuItem({
    required this.pubkey,
    required this.onLayout,
    required this.closeMenu,
  });

  final String pubkey;
  final void Function(Size) onLayout;
  final VoidCallback closeMenu;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isBlocked = ref.watch(isBlockedProvider(pubkey));
    return ContextMenuItem(
      label: isBlocked ? context.i18n.button_unblock : context.i18n.button_block,
      iconAsset: Assets.svg.iconBlockClose3,
      onLayout: onLayout,
      onPressed: () {
        closeMenu();
        if (!isBlocked) {
          showSimpleBottomSheet<void>(
            context: context,
            child: BlockUserModal(pubkey: pubkey),
          );
        } else {
          ref.read(blockListNotifierProvider.notifier).toggleBlocked(pubkey);
        }
      },
    );
  }
}
