// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/overlay_menu/components/overlay_menu_item.dart';
import 'package:ion/app/components/overlay_menu/components/overlay_menu_item_separator.dart';
import 'package:ion/app/components/overlay_menu/overlay_menu.dart';
import 'package:ion/app/components/overlay_menu/overlay_menu_container.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/chat/providers/muted_conversations_provider.c.dart';
import 'package:ion/app/features/user/providers/report_notifier.c.dart';
import 'package:ion/app/router/app_routes.c.dart';
import 'package:ion/generated/assets.gen.dart';

class MessagingContextMenu extends ConsumerWidget {
  const MessagingContextMenu({
    required this.conversationId,
    super.key,
    this.onToggleMute,
  });

  final String conversationId;
  final VoidCallback? onToggleMute;
  static double get iconSize => 20.0.s;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isMuted =
        ref.watch(mutedConversationIdsProvider).valueOrNull?.contains(conversationId) ?? false;

    ref.displayErrors(reportNotifierProvider);

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
                        ? IconAssetColored(
                            Assets.svgIconChannelUnmute,
                            size: iconSize,
                            color: context.theme.appColors.quaternaryText,
                          )
                        : IconAssetColored(
                            Assets.svgIconChannelMute,
                            size: iconSize,
                            color: context.theme.appColors.quaternaryText,
                          ),
                    onPressed: () {
                      closeMenu();
                      onToggleMute?.call();
                    },
                  ),
                  const OverlayMenuItemSeparator(),
                  OverlayMenuItem(
                    label: context.i18n.button_block,
                    icon: IconAssetColored(
                      Assets.svgIconPhofileBlockuser,
                      size: iconSize,
                      color: context.theme.appColors.quaternaryText,
                    ),
                    onPressed: closeMenu,
                  ),
                  const OverlayMenuItemSeparator(),
                  OverlayMenuItem(
                    label: context.i18n.button_report,
                    icon: IconAssetColored(
                      Assets.svgIconBlockClose3,
                      size: iconSize,
                      color: context.theme.appColors.quaternaryText,
                    ),
                    onPressed: () {
                      closeMenu();
                      ref
                          .read(reportNotifierProvider.notifier)
                          .report(ReportReason.conversation(conversationId: conversationId));
                    },
                  ),
                  const OverlayMenuItemSeparator(),
                  OverlayMenuItem(
                    label: context.i18n.button_delete,
                    labelColor: context.theme.appColors.attentionRed,
                    icon: IconAssetColored(
                      Assets.svgIconBlockDelete,
                      size: iconSize,
                      color: context.theme.appColors.attentionRed,
                    ),
                    onPressed: () async {
                      closeMenu();
                      final deleted = await DeleteConversationRoute(
                            conversationIds: [conversationId],
                          ).push<bool>(context) ??
                          false;

                      if (deleted && context.mounted) {
                        context.pop();
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      child: IconAssetColored(
        Assets.svgIconMorePopup,
        color: context.theme.appColors.onTertararyBackground,
      ),
    );
  }
}
