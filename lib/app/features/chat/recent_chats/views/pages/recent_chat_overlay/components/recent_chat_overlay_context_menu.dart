// SPDX-License-Identifier: ice License 1.0

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/overlay_menu/components/overlay_menu_item.dart';
import 'package:ion/app/components/overlay_menu/components/overlay_menu_item_separator.dart';
import 'package:ion/app/components/overlay_menu/overlay_menu_container.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/chat/e2ee/data/models/entities/private_direct_message_data.c.dart';
import 'package:ion/app/features/chat/providers/muted_conversations_provider.c.dart';
import 'package:ion/app/features/chat/recent_chats/model/conversation_list_item.c.dart';
import 'package:ion/app/features/chat/recent_chats/providers/toggle_archive_conversation_provider.c.dart';
import 'package:ion/app/features/user/data/models/report_reason.c.dart';
import 'package:ion/app/features/user/pages/profile_page/pages/block_user_modal/block_user_modal.dart';
import 'package:ion/app/features/user/providers/report_notifier.c.dart';
import 'package:ion/app/features/user_block/optimistic_ui/block_user_provider.c.dart';
import 'package:ion/app/features/user_block/providers/block_list_notifier.c.dart';
import 'package:ion/app/router/app_routes.c.dart';
import 'package:ion/app/router/utils/show_simple_bottom_sheet.dart';
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
    final currentUserMasterPubkey = ref.watch(currentPubkeySelectorProvider);

    final isMuted = ref
            .watch(mutedConversationIdsProvider)
            .valueOrNull
            ?.contains(conversation.conversationId) ??
        false;

    final isBlocked = ref
        .watch(
          isBlockedNotifierProvider(conversation.receiverMasterPubkey(currentUserMasterPubkey)),
        )
        .valueOrNull;

    ref.displayErrors(reportNotifierProvider);

    return SizedBox(
      height: height,
      child: Padding(
        padding: EdgeInsetsDirectional.only(top: 6.0.s),
        child: OverlayMenuContainer(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 4.0.s),
            child: Column(
              children: [
                OverlayMenuItem(
                  label: conversation.isArchived
                      ? context.i18n.common_unarchive_single
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
                  label: isMuted ? context.i18n.button_unmute : context.i18n.button_mute,
                  verticalPadding: 12.0.s,
                  icon: isMuted
                      ? Assets.svg.iconChannelUnmute
                          .icon(size: iconSize, color: context.theme.appColors.quaternaryText)
                      : Assets.svg.iconChannelMute
                          .icon(size: iconSize, color: context.theme.appColors.quaternaryText),
                  onPressed: () {
                    final currentUserPubkey = ref.watch(currentPubkeySelectorProvider);
                    final receiverPubkey = ReplaceablePrivateDirectMessageData.fromEventMessage(
                      conversation.latestMessage!,
                    ).relatedPubkeys?.firstWhereOrNull((p) => p.value != currentUserPubkey)?.value;

                    if (receiverPubkey == null) {
                      return;
                    }

                    ref
                        .read(mutedConversationsProvider.notifier)
                        .toggleMutedMasterPubkey(receiverPubkey);
                    Navigator.of(context).pop();
                  },
                ),
                if (isBlocked != null && currentUserMasterPubkey != null)
                  Column(
                    children: [
                      const OverlayMenuItemSeparator(),
                      OverlayMenuItem(
                        label: isBlocked ? context.i18n.button_unblock : context.i18n.button_block,
                        verticalPadding: 12.0.s,
                        icon: Assets.svg.iconPhofileBlockuser
                            .icon(size: iconSize, color: context.theme.appColors.quaternaryText),
                        onPressed: () {
                          context.pop();
                          final masterPubkey =
                              conversation.receiverMasterPubkey(currentUserMasterPubkey);

                          if (!isBlocked) {
                            showSimpleBottomSheet<void>(
                              context: context,
                              child: BlockUserModal(pubkey: masterPubkey),
                            );
                          } else {
                            ref.read(toggleBlockNotifierProvider.notifier).toggle(masterPubkey);
                          }
                        },
                      ),
                    ],
                  ),
                const OverlayMenuItemSeparator(),
                OverlayMenuItem(
                  label: context.i18n.button_report,
                  verticalPadding: 12.0.s,
                  icon: Assets.svg.iconBlockClose3
                      .icon(size: iconSize, color: context.theme.appColors.quaternaryText),
                  onPressed: () {
                    final currentUserPubkey = ref.watch(currentPubkeySelectorProvider);
                    final receiverPubkey = ReplaceablePrivateDirectMessageData.fromEventMessage(
                      conversation.latestMessage!,
                    ).relatedPubkeys?.firstWhereOrNull((p) => p.value != currentUserPubkey)?.value;

                    if (receiverPubkey == null) {
                      return;
                    }

                    ref
                        .read(reportNotifierProvider.notifier)
                        .report(ReportReason.user(pubkey: receiverPubkey));
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
