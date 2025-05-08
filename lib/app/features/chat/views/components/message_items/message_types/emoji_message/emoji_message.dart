// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/chat/e2ee/model/entities/private_direct_message_data.c.dart';
import 'package:ion/app/features/chat/hooks/use_has_reaction.dart';
import 'package:ion/app/features/chat/model/message_list_item.c.dart';
import 'package:ion/app/features/chat/recent_chats/providers/replied_message_list_item_provider.c.dart';
import 'package:ion/app/features/chat/views/components/message_items/message_item_wrapper/message_item_wrapper.dart';
import 'package:ion/app/features/chat/views/components/message_items/message_metadata/message_metadata.dart';
import 'package:ion/app/features/chat/views/components/message_items/message_reactions/message_reactions.dart';
import 'package:ion/app/features/chat/views/components/message_items/message_types/reply_message/reply_message.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';

class EmojiMessage extends HookConsumerWidget {
  const EmojiMessage({
    required this.eventMessage,
    this.onTapReply,
    super.key,
  });

  final EventMessage eventMessage;
  final VoidCallback? onTapReply;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entity =
        useMemoized(() => ReplaceablePrivateDirectMessageEntity.fromEventMessage(eventMessage));

    final isMe = ref.watch(isCurrentUserSelectorProvider(eventMessage.masterPubkey));

    final hasReaction = useHasReaction(eventMessage, ref);

    final messageItem = TextItem(
      eventMessage: eventMessage,
      contentDescription: eventMessage.content,
    );

    final repliedEventMessage = ref.watch(repliedMessageListItemProvider(messageItem));

    final repliedMessageItem = getRepliedMessageListItem(
      ref: ref,
      repliedEventMessage: repliedEventMessage.valueOrNull,
    );

    return MessageItemWrapper(
      isMe: isMe,
      messageItem: messageItem,
      contentPadding: EdgeInsets.symmetric(horizontal: 12.0.s, vertical: 6.0.s),
      child: IntrinsicWidth(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (repliedMessageItem != null)
              ReplyMessage(messageItem, repliedMessageItem, onTapReply),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  entity.data.content,
                  style: context.theme.appTextThemes.headline1.copyWith(height: 1),
                ),
                if (!hasReaction) MessageMetaData(eventMessage: eventMessage),
              ],
            ),
            if (hasReaction)
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: MessageReactions(eventMessage: eventMessage, isMe: isMe),
                  ),
                  MessageMetaData(eventMessage: eventMessage, startPadding: 0.0.s),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
