// SPDX-License-Identifier: ice License 1.0

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/chat/e2ee/data/models/entities/private_direct_message_data.c.dart';
import 'package:ion/app/features/chat/e2ee/data/models/message_type.dart';
import 'package:ion/app/features/chat/views/components/message_items/components.dart';
import 'package:ion/app/features/chat/views/components/message_items/message_types/document_message/document_message.dart';
import 'package:ion/app/features/chat/views/components/message_items/message_types/post_message/post_message.dart';
import 'package:ion/app/features/chat/views/components/message_items/message_types/visual_media_message/visual_media_message.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class OneToOneMessageList extends HookConsumerWidget {
  const OneToOneMessageList(this.messages, {super.key});

  final Map<DateTime, List<EventMessage>> messages;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemScrollController = useMemoized(ItemScrollController.new);
    final allMessages = messages.values.expand((e) => e).toList()
      ..sortByCompare((e) => e.publishedAt, (a, b) => b.compareTo(a));

    final onTapReply = useCallback(
      (ReplaceablePrivateDirectMessageEntity entity) {
        final replyMessage = entity.data.relatedEvents?.singleOrNull;

        if (replyMessage != null) {
          final replyMessageIndex = allMessages.indexWhere(
            (element) => element.sharedId == replyMessage.eventReference.dTag,
          );
          itemScrollController.scrollTo(
            index: replyMessageIndex,
            duration: const Duration(milliseconds: 300),
          );
        }
      },
      [allMessages, itemScrollController],
    );

    return NotificationListener<ScrollUpdateNotification>(
      onNotification: (notification) {
        if (notification.scrollDelta != null && notification.scrollDelta! > 0) {
          FocusManager.instance.primaryFocus?.unfocus();
        }
        return false;
      },
      child: ColoredBox(
        color: context.theme.appColors.primaryBackground,
        child: ScreenSideOffset.small(
          child: ScrollablePositionedList.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: allMessages.length,
            itemScrollController: itemScrollController,
            reverse: true,
            itemBuilder: (context, index) {
              final message = allMessages[index];

              final entity = ReplaceablePrivateDirectMessageEntity.fromEventMessage(message);

              final displayDate = messages.entries
                  .singleWhereOrNull((entry) => entry.value.last.id == message.id)
                  ?.key;

              final previousMessage = index > 0 ? allMessages[index - 1] : null;
              final isLastMessage = index == 0;

              final isMessageFromAnotherAuthor =
                  previousMessage != null && previousMessage.masterPubkey != message.masterPubkey;

              final margin = EdgeInsetsDirectional.only(
                bottom: isLastMessage ? 20.0.s : 8.0.s,
                top: isMessageFromAnotherAuthor ? 8.0.s : 0,
              );

              return Column(
                key: Key(message.id),
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (displayDate != null)
                    Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 12.0.s),
                        child: ChatDateHeaderText(date: displayDate),
                      ),
                    ),
                  switch (entity.data.messageType) {
                    MessageType.text => TextMessage(
                        margin: margin,
                        eventMessage: message,
                        onTapReply: () => onTapReply(entity),
                      ),
                    MessageType.profile => ProfileShareMessage(
                        margin: margin,
                        eventMessage: message,
                        onTapReply: () => onTapReply(entity),
                      ),
                    MessageType.visualMedia => VisualMediaMessage(
                        margin: margin,
                        eventMessage: message,
                        onTapReply: () => onTapReply(entity),
                      ),
                    MessageType.sharedPost => PostMessage(
                        margin: margin,
                        eventMessage: message,
                        onTapReply: () => onTapReply(entity),
                      ),
                    MessageType.requestFunds || MessageType.moneySent => MoneyMessage(
                        margin: margin,
                        eventMessage: message,
                        onTapReply: () => onTapReply(entity),
                      ),
                    MessageType.emoji => EmojiMessage(
                        margin: margin,
                        eventMessage: message,
                        onTapReply: () => onTapReply(entity),
                      ),
                    MessageType.audio => AudioMessage(
                        margin: margin,
                        eventMessage: message,
                        onTapReply: () => onTapReply(entity),
                      ),
                    MessageType.document => DocumentMessage(
                        margin: margin,
                        eventMessage: message,
                        onTapReply: () => onTapReply(entity),
                      ),
                  },
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
