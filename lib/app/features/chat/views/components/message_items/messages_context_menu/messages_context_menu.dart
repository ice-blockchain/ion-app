// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/overlay_menu/components/overlay_menu_item.dart';
import 'package:ion/app/components/overlay_menu/components/overlay_menu_item_separator.dart';
import 'package:ion/app/components/overlay_menu/overlay_menu.dart';
import 'package:ion/app/components/overlay_menu/overlay_menu_container.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/chat/providers/muted_conversations_provider.c.dart';
import 'package:ion/generated/assets.gen.dart';

class MessagingContextMenu extends ConsumerWidget {
  const MessagingContextMenu({super.key, this.conversationId, this.onToggleMute});

  final String? conversationId;
  final VoidCallback? onToggleMute;
  static double get iconSize => 20.0.s;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isMuted =
        ref.watch(mutedConversationIdsProvider).valueOrNull?.contains(conversationId) ?? false;

    return OverlayMenu(
      menuBuilder: (closeMenu) => Column(
        children: [
          OverlayMenuContainer(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 4.0.s),
              child: Column(
                children: [
                  OverlayMenuItem(
                    label: isMuted ? context.i18n.button_unmute : context.i18n.button_mute,
                    icon: isMuted
                        ? Assets.svg.iconChannelUnmute
                            .icon(size: iconSize, color: context.theme.appColors.quaternaryText)
                        : Assets.svg.iconChannelMute
                            .icon(size: iconSize, color: context.theme.appColors.quaternaryText),
                    onPressed: () {
                      closeMenu();
                      onToggleMute?.call();
                    },
                  ),
                  const OverlayMenuItemSeparator(),
                  OverlayMenuItem(
                    label: context.i18n.button_block,
                    icon: Assets.svg.iconPhofileBlockuser
                        .icon(size: iconSize, color: context.theme.appColors.quaternaryText),
                    onPressed: closeMenu,
                  ),
                  const OverlayMenuItemSeparator(),
                  OverlayMenuItem(
                    label: context.i18n.button_report,
                    icon: Assets.svg.iconBlockClose3
                        .icon(size: iconSize, color: context.theme.appColors.quaternaryText),
                    onPressed: closeMenu,
                  ),
                  const OverlayMenuItemSeparator(),
                  OverlayMenuItem(
                    label: context.i18n.button_delete,
                    labelColor: context.theme.appColors.attentionRed,
                    icon: Assets.svg.iconBlockDelete
                        .icon(size: iconSize, color: context.theme.appColors.attentionRed),
                    onPressed: closeMenu,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      child: Assets.svg.iconMorePopup.icon(
        color: context.theme.appColors.onTertararyBackground,
      ),
    );
  }
}
