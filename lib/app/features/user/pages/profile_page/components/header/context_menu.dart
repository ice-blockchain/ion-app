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
      offset: Offset(-menuWidth.value + HeaderAction.buttonSize, 6.0.s),
      menuBuilder: (closeMenu) => OverlayMenuContainer(
        child: IntrinsicWidth(
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
              ContextMenuItem(
                label: context.i18n.button_block,
                iconAsset: Assets.svg.iconBlockClose3,
                onPressed: () {
                  showSimpleBottomSheet<void>(
                    context: context,
                    child: BlockUserModal(
                      pubkey: pubkey,
                    ),
                  );
                },
                onLayout: updateWidth,
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
