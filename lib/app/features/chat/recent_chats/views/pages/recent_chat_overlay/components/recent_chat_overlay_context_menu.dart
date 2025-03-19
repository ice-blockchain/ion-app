// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/overlay_menu/components/overlay_menu_item.dart';
import 'package:ion/app/components/overlay_menu/components/overlay_menu_item_separator.dart';
import 'package:ion/app/components/overlay_menu/overlay_menu_container.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/chat/recent_chats/model/conversation_list_item.c.dart';
import 'package:ion/app/features/chat/recent_chats/providers/toggle_archive_conversation_provider.c.dart';
import 'package:ion/app/router/app_routes.c.dart';
import 'package:ion/generated/assets.gen.dart';

class RecentChatOverlayContextMenu extends ConsumerWidget {
  const RecentChatOverlayContextMenu({
    required this.conversation,
    super.key,
  });

  final ConversationListItem conversation;

  static final height = 237.0.s;
  static double get iconSize => 20.0.s;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      height: height,
      child: Padding(
        padding: EdgeInsets.only(top: 6.0.s),
        child: OverlayMenuContainer(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 4.0.s),
            child: Column(
              children: [
                OverlayMenuItem(
                  label: conversation.isArchived
                      ? context.i18n.common_unarchive
                      : context.i18n.common_add_to_archive,
                  icon: Assets.svg.iconChatArchive.icon(
                    size: iconSize,
                    color: context.theme.appColors.quaternaryText,
                  ),
                  onPressed: () {
                    ref
                        .read(toggleArchivedConversationsProvider.notifier)
                        .toggleConversations([conversation]);
                    Navigator.of(context).pop();
                  },
                  minWidth: 128.0.s,
                  verticalPadding: 12.0.s,
                ),
                const OverlayMenuItemSeparator(),
                OverlayMenuItem(
                  label: context.i18n.button_mute,
                  verticalPadding: 12.0.s,
                  icon: Assets.svg.iconChannelMute
                      .icon(size: iconSize, color: context.theme.appColors.quaternaryText),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                const OverlayMenuItemSeparator(),
                OverlayMenuItem(
                  label: context.i18n.button_block,
                  verticalPadding: 12.0.s,
                  icon: Assets.svg.iconPhofileBlockuser
                      .icon(size: iconSize, color: context.theme.appColors.quaternaryText),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                const OverlayMenuItemSeparator(),
                OverlayMenuItem(
                  label: context.i18n.button_report,
                  verticalPadding: 12.0.s,
                  icon: Assets.svg.iconBlockClose3
                      .icon(size: iconSize, color: context.theme.appColors.quaternaryText),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                const OverlayMenuItemSeparator(),
                OverlayMenuItem(
                  label: context.i18n.button_delete,
                  labelColor: context.theme.appColors.attentionRed,
                  verticalPadding: 12.0.s,
                  icon: Assets.svg.iconBlockDelete
                      .icon(size: iconSize, color: context.theme.appColors.attentionRed),
                  onPressed: () async {
                    final deleted = await DeleteConversationRoute(
                          conversationIds: [conversation.conversationId],
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
      ),
    );
  }
}
