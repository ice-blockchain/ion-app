// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/overlay_menu/overlay_menu.dart';
import 'package:ion/app/components/overlay_menu/overlay_menu_container.dart';
import 'package:ion/app/extensions/asset_gen_image.dart';
import 'package:ion/app/extensions/build_context.dart';
import 'package:ion/app/extensions/num.dart';
import 'package:ion/app/extensions/theme_data.dart';
import 'package:ion/app/features/core/views/pages/unfollow_user_page.dart';
import 'package:ion/app/features/feed/views/components/user_info_menu/user_info_menu_item.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_cache.c.dart';
import 'package:ion/app/features/user/model/user_metadata.c.dart';
import 'package:ion/app/features/user/pages/profile_page/pages/block_user_modal/block_user_modal.dart';
import 'package:ion/app/features/user/providers/block_list_notifier.c.dart';
import 'package:ion/app/features/user/providers/follow_list_provider.c.dart';
import 'package:ion/app/router/utils/show_simple_bottom_sheet.dart';
import 'package:ion/generated/assets.gen.dart';

class UserInfoMenu extends ConsumerWidget {
  const UserInfoMenu({
    required this.pubkey,
    this.iconColor,
    super.key,
  });

  static double get iconSize => 20.0.s;

  final String pubkey;
  final Color? iconColor;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userMetadata = ref.watch(
      ionConnectCacheProvider.select(
        cacheSelector<UserMetadataEntity>(UserMetadataEntity.cacheKeyBuilder(pubkey: pubkey)),
      ),
    );

    if (userMetadata == null) {
      return const SizedBox.shrink();
    }

    return OverlayMenu(
      menuBuilder: (closeMenu) => Column(
        children: [
          OverlayMenuContainer(
            child: UserInfoMenuItem(
              label: context.i18n.post_menu_not_interested,
              icon: Assets.svg.iconNotinterested.icon(size: iconSize),
              onPressed: closeMenu,
            ),
          ),
          SizedBox(height: 14.0.s),
          OverlayMenuContainer(
            child: Column(
              children: [
                _FollowUserMenuItem(
                  pubkey: pubkey,
                  username: userMetadata.data.name,
                  closeMenu: closeMenu,
                ),
                _BlockUserMenuItem(
                  pubkey: pubkey,
                  username: userMetadata.data.name,
                  closeMenu: closeMenu,
                ),
                UserInfoMenuItem(
                  label: context.i18n.post_menu_report_post,
                  icon: Assets.svg.iconReport.icon(size: iconSize),
                  onPressed: closeMenu,
                ),
              ],
            ),
          ),
        ],
      ),
      child: Assets.svg.iconMorePopup.icon(
        color: iconColor ?? context.theme.appColors.onTertararyBackground,
      ),
    );
  }
}

class _FollowUserMenuItem extends ConsumerWidget {
  const _FollowUserMenuItem({
    required this.pubkey,
    required this.username,
    required this.closeMenu,
  });

  final String pubkey;
  final String username;
  final VoidCallback closeMenu;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final following = ref.watch(isCurrentUserFollowingSelectorProvider(pubkey));
    return UserInfoMenuItem(
      label: following
          ? context.i18n.post_menu_unfollow_nickname(username)
          : context.i18n.post_menu_follow_nickname(username),
      icon: Assets.svg.iconFollowuser.icon(
        size: UserInfoMenu.iconSize,
        color: context.theme.appColors.onTertararyBackground,
      ),
      onPressed: () {
        if (following) {
          showSimpleBottomSheet<void>(
            context: context,
            child: UnfollowUserModal(pubkey: pubkey),
          );
          closeMenu();
        } else {
          ref.read(followListManagerProvider.notifier).toggleFollow(pubkey);
          closeMenu();
        }
      },
    );
  }
}

class _BlockUserMenuItem extends ConsumerWidget {
  const _BlockUserMenuItem({
    required this.pubkey,
    required this.username,
    required this.closeMenu,
  });

  final String pubkey;
  final String username;
  final VoidCallback closeMenu;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isBlocked = ref.watch(isBlockedProvider(pubkey)).value ?? false;
    return UserInfoMenuItem(
      label: isBlocked
          ? context.i18n.post_menu_unblock_nickname(username)
          : context.i18n.post_menu_block_nickname(username),
      icon: Assets.svg.iconBlock.icon(size: UserInfoMenu.iconSize),
      onPressed: () {
        if (!isBlocked) {
          showSimpleBottomSheet<void>(
            context: context,
            child: BlockUserModal(pubkey: pubkey),
          );
          closeMenu();
        } else {
          ref.read(blockListNotifierProvider.notifier).toggleBlocked(pubkey);
          closeMenu();
        }
      },
    );
  }
}
