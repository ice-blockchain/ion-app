// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/overlay_menu/components/overlay_menu_item.dart';
import 'package:ion/app/components/overlay_menu/components/overlay_menu_item_separator.dart';
import 'package:ion/app/components/overlay_menu/overlay_menu_container.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/chat/e2ee/model/entities/private_direct_message_data.c.dart';
import 'package:ion/app/features/chat/e2ee/providers/e2ee_delete_event_provider.c.dart';
import 'package:ion/app/features/chat/e2ee/providers/send_chat_message/send_e2ee_chat_message_service.c.dart';
import 'package:ion/app/features/chat/model/database/chat_database.c.dart';
import 'package:ion/app/features/chat/model/message_list_item.c.dart';
import 'package:ion/app/features/chat/recent_chats/providers/selected_edit_message_provider.c.dart';
import 'package:ion/app/features/chat/recent_chats/providers/selected_reply_message_provider.c.dart';
import 'package:ion/app/features/core/model/feature_flags.dart';
import 'package:ion/app/features/core/providers/feature_flags_provider.c.dart';
import 'package:ion/app/router/app_routes.c.dart';
import 'package:ion/generated/assets.gen.dart';

class MessageReactionContextMenu extends HookConsumerWidget {
  const MessageReactionContextMenu({
    required this.isMe,
    required this.height,
    required this.messageItem,
    required this.messageStatus,
    super.key,
  });

  final bool isMe;
  final double height;
  final ChatMessageInfoItem messageItem;
  final MessageDeliveryStatus messageStatus;

  static double get iconSize => 20.0.s;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final canEdit = useMemoized(
      () {
        final entityData =
            ReplaceablePrivateDirectMessageData.fromEventMessage(messageItem.eventMessage);
        return entityData.editingEndedAt.value.isAfter(DateTime.now());
      },
    );
    final hideChatBookmark =
        ref.watch(featureFlagsProvider.notifier).get(ChatFeatureFlag.hideChatBookmark);

    return SizedBox(
      height: height,
      child: Padding(
        padding: EdgeInsetsDirectional.only(top: 6.0.s),
        child: OverlayMenuContainer(
          child: Column(
            children: [
              if (messageStatus == MessageDeliveryStatus.failed)
                OverlayMenuItem(
                  label: context.i18n.button_retry,
                  icon: Assets.svg.iconMessageRetry.icon(
                    size: iconSize,
                    color: context.theme.appColors.quaternaryText,
                  ),
                  onPressed: () async {
                    unawaited(
                      ref.read(sendE2eeChatMessageServiceProvider).resendMessage(
                            messageEvent: messageItem.eventMessage,
                          ),
                    );

                    if (context.mounted) {
                      context.pop();
                    }
                  },
                  minWidth: 140.0.s,
                  verticalPadding: 12.0.s,
                )
              else ...[
                OverlayMenuItem(
                  label: context.i18n.button_reply,
                  icon: Assets.svg.iconChatReply.icon(
                    size: iconSize,
                    color: context.theme.appColors.quaternaryText,
                  ),
                  onPressed: () {
                    ref.read(selectedReplyMessageProvider.notifier).selectedReplyMessage =
                        messageItem;
                    context.pop();
                  },
                  minWidth: 140.0.s,
                  verticalPadding: 12.0.s,
                ),
                const OverlayMenuItemSeparator(),
                if (isMe && canEdit && (messageItem is TextItem || messageItem is EmojiItem))
                  OverlayMenuItem(
                    label: context.i18n.button_edit,
                    verticalPadding: 12.0.s,
                    icon: Assets.svg.iconEditLink
                        .icon(size: iconSize, color: context.theme.appColors.quaternaryText),
                    onPressed: () {
                      ref.read(selectedReplyMessageProvider.notifier).clear();
                      ref.read(selectedEditMessageProvider.notifier).selectedEditMessage =
                          messageItem;
                      context.pop();
                    },
                  )
                else
                  OverlayMenuItem(
                    label: context.i18n.button_forward,
                    verticalPadding: 12.0.s,
                    icon: Assets.svg.iconChatForward
                        .icon(size: iconSize, color: context.theme.appColors.quaternaryText),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                const OverlayMenuItemSeparator(),
                OverlayMenuItem(
                  label: context.i18n.button_copy,
                  verticalPadding: 12.0.s,
                  icon: Assets.svg.iconBlockCopyBlue
                      .icon(size: iconSize, color: context.theme.appColors.quaternaryText),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                if (!hideChatBookmark) ...[
                  const OverlayMenuItemSeparator(),
                  OverlayMenuItem(
                    label: context.i18n.button_bookmark,
                    verticalPadding: 12.0.s,
                    icon: Assets.svg.iconBookmarks
                        .icon(size: iconSize, color: context.theme.appColors.quaternaryText),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ],
              const OverlayMenuItemSeparator(),
              OverlayMenuItem(
                label: context.i18n.button_delete,
                labelColor: context.theme.appColors.attentionRed,
                verticalPadding: 12.0.s,
                icon: Assets.svg.iconBlockDelete
                    .icon(size: iconSize, color: context.theme.appColors.attentionRed),
                onPressed: () async {
                  final forEveryone = await DeleteMessageRoute(
                    isMe: isMe,
                  ).push<bool>(context);

                  if (forEveryone != null && context.mounted) {
                    final messageEventsList = [messageItem.eventMessage];
                    ref.read(
                      e2eeDeleteMessageProvider(
                        forEveryone: forEveryone,
                        messageEvents: messageEventsList,
                      ),
                    );
                    context.pop();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
