// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/overlay_menu/components/overlay_menu_item.dart';
import 'package:ion/app/components/overlay_menu/overlay_menu.dart';
import 'package:ion/app/components/overlay_menu/overlay_menu_container.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/core/views/pages/unfollow_user_page.dart';
import 'package:ion/app/features/feed/data/models/entities/article_data.c.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';
import 'package:ion/app/features/user/pages/profile_page/pages/block_user_modal/block_user_modal.dart';
import 'package:ion/app/features/user/providers/block_list_notifier.c.dart';
import 'package:ion/app/features/user/providers/follow_list_provider.c.dart';
import 'package:ion/app/features/user/providers/report_notifier.c.dart';
import 'package:ion/app/features/user/providers/user_metadata_provider.c.dart';
import 'package:ion/app/router/utils/show_simple_bottom_sheet.dart';
import 'package:ion/generated/assets.gen.dart';

class UserInfoMenu extends ConsumerWidget {
  const UserInfoMenu({
    required this.eventReference,
    this.iconColor,
    this.reportTitle,
    super.key,
  });

  static double get iconSize => 20.0.s;

  final EventReference eventReference;
  final Color? iconColor;
  final String? reportTitle;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userMetadata = ref.watch(cachedUserMetadataProvider(eventReference.pubkey));
    final isArticle = eventReference is ReplaceableEventReference &&
        (eventReference as ReplaceableEventReference).kind == ArticleEntity.kind;

    if (userMetadata == null) {
      return const SizedBox.shrink();
    }

    ref.displayErrors(reportNotifierProvider);

    return OverlayMenu(
      menuBuilder: (closeMenu) => ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 300.0.s),
        child: Column(
          children: [
            OverlayMenuContainer(
              child: OverlayMenuItem(
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
                    pubkey: eventReference.pubkey,
                    username: userMetadata.data.name,
                    closeMenu: closeMenu,
                  ),
                  _BlockUserMenuItem(
                    pubkey: eventReference.pubkey,
                    username: userMetadata.data.name,
                    closeMenu: closeMenu,
                  ),
                  OverlayMenuItem(
                    label: isArticle
                        ? context.i18n.article_menu_report_article
                        : context.i18n.post_menu_report_post,
                    icon: Assets.svg.iconReport.icon(size: iconSize),
                    onPressed: () {
                      closeMenu();
                      ref
                          .read(reportNotifierProvider.notifier)
                          .report(ReportReason.content(eventReference: eventReference));
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
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
    ref.displayErrors(followListManagerProvider);
    final following = ref.watch(isCurrentUserFollowingSelectorProvider(pubkey));
    return OverlayMenuItem(
      label: following
          ? context.i18n.post_menu_unfollow_nickname(username)
          : context.i18n.post_menu_follow_nickname(username),
      icon: Assets.svg.iconFollowuser.icon(
        size: UserInfoMenu.iconSize,
        color: context.theme.appColors.onTertararyBackground,
      ),
      onPressed: () {
        closeMenu();
        if (following) {
          showSimpleBottomSheet<void>(
            context: context,
            child: UnfollowUserModal(pubkey: pubkey),
          );
        } else {
          ref.read(followListManagerProvider.notifier).toggleFollow(pubkey);
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
    final isBlocked = ref.watch(isBlockedProvider(pubkey));
    return OverlayMenuItem(
      label: isBlocked
          ? context.i18n.post_menu_unblock_nickname(username)
          : context.i18n.post_menu_block_nickname(username),
      icon: Assets.svg.iconBlock.icon(size: UserInfoMenu.iconSize),
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
