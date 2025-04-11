// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/button/button.dart';
import 'package:ion/app/components/list_item/list_item.dart';
import 'package:ion/app/components/overlay_menu/overlay_menu.dart';
import 'package:ion/app/components/overlay_menu/overlay_menu_container.dart';
import 'package:ion/app/extensions/asset_gen_image.dart';
import 'package:ion/app/extensions/build_context.dart';
import 'package:ion/app/extensions/num.dart';
import 'package:ion/app/extensions/theme_data.dart';
import 'package:ion/app/features/components/bookmarks/confirm_bookmarks_collection_delete_popup.dart';
import 'package:ion/app/features/components/bookmarks/edit_bookmarks_collection_popup.dart';
import 'package:ion/app/features/user/pages/profile_page/components/header/context_menu_item.dart';
import 'package:ion/app/features/user/pages/profile_page/components/header/context_menu_item_divider.dart';
import 'package:ion/app/router/utils/show_simple_bottom_sheet.dart';
import 'package:ion/generated/assets.gen.dart';

enum BookmarksCollectionTileMode { main, checkbox, menu }

class BookmarksCollectionTile extends ConsumerWidget {
  const BookmarksCollectionTile({
    required this.collectionName,
    required this.bookmarksAmount,
    required this.isSelected,
    required this.mode,
    super.key,
  });

  final String collectionName;
  final int bookmarksAmount;
  final bool isSelected;
  final BookmarksCollectionTileMode mode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0.s),
      child: ListItem(
        onTap: () {},
        leading: ButtonIconFrame(
          containerSize: 36.0.s,
          color: context.theme.appColors.secondaryBackground,
          borderRadius: BorderRadius.circular(12.0.s),
          border: Border.all(color: context.theme.appColors.onTerararyFill),
          icon: Assets.svg.iconFolderOpen.icon(color: context.theme.appColors.primaryAccent),
        ),
        title: Text(
          collectionName,
          style: context.theme.appTextThemes.subtitle2.copyWith(
            color: context.theme.appColors.primaryText,
          ),
        ),
        subtitle: Text(
          bookmarksAmount.toString(),
          style: context.theme.appTextThemes.caption2.copyWith(
            color: context.theme.appColors.quaternaryText,
          ),
        ),
        trailing: _getTrailingWidget(),
        contentPadding: EdgeInsets.symmetric(horizontal: 16.0.s, vertical: 12.0.s),
        backgroundColor: context.theme.appColors.tertararyBackground,
      ),
    );
  }

  Widget? _getTrailingWidget() {
    return switch (mode) {
      BookmarksCollectionTileMode.main =>
        isSelected ? Assets.svg.iconBookmarksOn.icon() : Assets.svg.iconBookmarks.icon(),
      BookmarksCollectionTileMode.checkbox => isSelected
          ? Assets.svg.iconBlockCheckboxOnblue.icon()
          : Assets.svg.iconBlockCheckboxOff.icon(),
      BookmarksCollectionTileMode.menu => const _OverlayMenu()
    };
  }
}

class _OverlayMenu extends ConsumerWidget {
  const _OverlayMenu();

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
                  child: const EditBookmarksCollectionPopup(
                    pubkey: 'pubkey',
                  ),
                );
              },
              onLayout: (_) {},
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
                  child: const ConfirmBookmarksCollectionDeletePopup(
                    pubkey: 'pubkey',
                  ),
                );
              },
              onLayout: (_) {},
            ),
          ],
        ),
      ),
      child: Assets.svg.iconMorePopup.icon(),
    );
  }
}
