// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/chat/e2ee/model/entities/private_direct_message_data.c.dart';
import 'package:ion/app/features/chat/e2ee/providers/chat_medias_provider.c.dart';
import 'package:ion/app/features/chat/model/message_list_item.c.dart';
import 'package:ion/app/features/chat/recent_chats/providers/replied_message_list_item_provider.c.dart';
import 'package:ion/app/features/chat/views/components/message_items/message_item_wrapper/message_item_wrapper.dart';
import 'package:ion/app/features/chat/views/components/message_items/message_types/reply_message/reply_message.dart';
import 'package:ion/app/features/chat/views/components/message_items/message_types/visual_media_message/visual_media_custom_grid.dart';
import 'package:ion/app/features/chat/views/components/message_items/message_types/visual_media_message/visual_media_metadata.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';

class VisualMediaMessage extends HookConsumerWidget {
  const VisualMediaMessage({
    required this.eventMessage,
    this.onTapReply,
    super.key,
  });

  final VoidCallback? onTapReply;
  final EventMessage eventMessage;

  static double get padding => 6.0.s;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useAutomaticKeepAlive();

    final eventReference =
        ReplaceablePrivateDirectMessageEntity.fromEventMessage(eventMessage).toEventReference();

    final isMe = ref.watch(isCurrentUserSelectorProvider(eventMessage.masterPubkey));
    final messageMedias =
        ref.watch(chatMediasProvider(eventReference: eventReference)).valueOrNull ?? [];

    final messageItem = MediaItem(
      eventMessage: eventMessage,
      contentDescription: context.i18n.common_media,
      medias: messageMedias,
    );

    final repliedEventMessage = ref.watch(repliedMessageListItemProvider(messageItem));

    final repliedMessageItem = getRepliedMessageListItem(
      ref: ref,
      repliedEventMessage: repliedEventMessage.valueOrNull,
    );

    return MessageItemWrapper(
      isMe: isMe,
      messageItem: MediaItem(
        medias: messageMedias,
        eventMessage: eventMessage,
        contentDescription: context.i18n.common_media,
      ),
      contentPadding: EdgeInsets.all(padding),
      child: SizedBox(
        width: messageMedias.length > 1 || repliedEventMessage.valueOrNull != null
            ? double.infinity
            : 146.0.s,
        child: Column(
          children: [
            if (repliedMessageItem != null)
              ReplyMessage(messageItem, repliedMessageItem, onTapReply),
            VisualMediaCustomGrid(
              messageMedias: messageMedias,
              eventMessage: eventMessage,
            ),
            VisualMediaMetadata(eventMessage: eventMessage),
          ],
        ),
      ),
    );
  }
}
