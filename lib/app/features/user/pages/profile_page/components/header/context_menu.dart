// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/overlay_menu/overlay_menu.dart';
import 'package:ion/app/components/overlay_menu/overlay_menu_container.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/ion_connect/data/models/event_reference.c.dart';
import 'package:ion/app/features/user/data/models/report_reason.c.dart';
import 'package:ion/app/features/user/data/models/user_metadata.c.dart';
import 'package:ion/app/features/user/pages/components/header_action/header_action.dart';
import 'package:ion/app/features/user/pages/profile_page/components/header/context_menu_item.dart';
import 'package:ion/app/features/user/pages/profile_page/components/header/context_menu_item_divider.dart';
import 'package:ion/app/features/user/pages/profile_page/pages/block_user_modal/block_user_modal.dart';
import 'package:ion/app/features/user/providers/report_notifier.c.dart';
import 'package:ion/app/features/user_block/optimistic_ui/block_user_provider.c.dart';
import 'package:ion/app/features/user_block/providers/block_list_notifier.c.dart';
import 'package:ion/app/router/app_routes.c.dart';
import 'package:ion/app/router/utils/show_simple_bottom_sheet.dart';
import 'package:ion/generated/assets.gen.dart';

class ContextMenu extends ConsumerWidget {
  const ContextMenu({
    required this.pubkey,
    this.opacity = 1,
    super.key,
  });

  final String pubkey;
  final double opacity;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.displayErrors(reportNotifierProvider);

    return OverlayMenu(
      menuBuilder: (closeMenu) => OverlayMenuContainer(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ContextMenuItem(
              label: context.i18n.button_share,
              iconAsset: Assets.svg.iconButtonShare,
              onPressed: () {
                closeMenu();
                ShareViaMessageModalRoute(
                  eventReference:
                      ReplaceableEventReference(pubkey: pubkey, kind: UserMetadataEntity.kind)
                          .encode(),
                ).push<void>(context);
              },
            ),
            const ContextMenuItemDivider(),
            _BlockUserMenuItem(
              masterPubkey: pubkey,
              closeMenu: closeMenu,
            ),
            const ContextMenuItemDivider(),
            ContextMenuItem(
              label: context.i18n.button_report,
              iconAsset: Assets.svg.iconReport,
              onPressed: () {
                closeMenu();
                ref.read(reportNotifierProvider.notifier).report(ReportReason.user(pubkey: pubkey));
              },
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
    required this.masterPubkey,
    required this.closeMenu,
  });

  final String masterPubkey;
  final VoidCallback closeMenu;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isBlocked = ref.watch(isBlockedNotifierProvider(masterPubkey)).valueOrNull ?? false;
    return ContextMenuItem(
      label: isBlocked ? context.i18n.button_unblock : context.i18n.button_block,
      iconAsset: Assets.svg.iconBlockClose3,
      onPressed: () {
        closeMenu();
        if (!isBlocked) {
          showSimpleBottomSheet<void>(
            context: context,
            child: BlockUserModal(pubkey: masterPubkey),
          );
        } else {
          ref.read(toggleBlockNotifierProvider.notifier).toggle(masterPubkey);
        }
      },
    );
  }
}
