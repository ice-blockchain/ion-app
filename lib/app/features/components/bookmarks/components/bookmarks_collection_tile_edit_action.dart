// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/overlay_menu/overlay_menu.dart';
import 'package:ion/app/components/overlay_menu/overlay_menu_container.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/components/bookmarks/confirm_bookmarks_collection_delete_popup.dart';
import 'package:ion/app/features/components/bookmarks/edit_bookmarks_collection_popup.dart';
import 'package:ion/app/features/feed/data/models/bookmarks/bookmarks_set.c.dart';
import 'package:ion/app/features/user/pages/profile_page/components/header/context_menu_item.dart';
import 'package:ion/app/features/user/pages/profile_page/components/header/context_menu_item_divider.dart';
import 'package:ion/app/router/utils/show_simple_bottom_sheet.dart';
import 'package:ion/generated/assets.gen.dart';

class BookmarksCollectionTileEditAction extends ConsumerWidget {
  const BookmarksCollectionTileEditAction({
    required this.data,
    super.key,
  });

  final BookmarksSetData data;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return OverlayMenu(
      menuBuilder: (closeMenu) => OverlayMenuContainer(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ContextMenuItem(
              label: context.i18n.button_edit,
              iconAsset: Assets.svg.iconEditLink,
              onPressed: () async {
                closeMenu();
                await showSimpleBottomSheet<String>(
                  context: context,
                  child: EditBookmarksCollectionPopup(
                    data: data,
                  ),
                );
              },
            ),
            const ContextMenuItemDivider(),
            ContextMenuItem(
              label: context.i18n.button_delete,
              iconAsset: Assets.svg.iconBlockDelete,
              iconColor: context.theme.appColors.attentionRed,
              textColor: context.theme.appColors.attentionRed,
              onPressed: () async {
                closeMenu();
                await showSimpleBottomSheet<String>(
                  context: context,
                  child: ConfirmBookmarksCollectionDeletePopup(
                    data: data,
                  ),
                );
              },
            ),
          ],
        ),
      ),
      child: Assets.svg.iconMorePopup.icon(),
    );
  }
}
