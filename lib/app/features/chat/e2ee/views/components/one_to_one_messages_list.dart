// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/chat/e2ee/model/entities/private_direct_message_data.c.dart';
import 'package:ion/app/features/chat/e2ee/providers/send_e2ee_message_status_provider.c.dart';
import 'package:ion/app/features/chat/model/database/chat_database.c.dart';
import 'package:ion/app/features/chat/model/message_type.dart';
import 'package:ion/app/features/chat/views/components/message_items/components.dart';
import 'package:ion/app/features/chat/views/components/message_items/message_types/document_message/document_message.dart';
import 'package:ion/app/features/chat/views/components/message_items/message_types/story_reply_message/story_reply_message.dart';
import 'package:ion/app/features/chat/views/components/message_items/message_types/visual_media_message/visual_media_message.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class OneToOneMessageList extends HookConsumerWidget {
  const OneToOneMessageList(this.messages, {super.key});

  final List<EventMessage> messages;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemScrollController = useMemoized(ItemScrollController.new);
    useEffect(
      () {
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          if (messages.isNotEmpty) {
            unawaited(
              ref.watch(sendE2eeMessageStatusServiceProvider.future).then((value) {
                value.sendMessageStatus(
                  messageEventMessage: messages.last,
                  status: MessageDeliveryStatus.read,
                );
              }),
            );
          }
        });
        return null;
      },
      [messages],
    );

    final onTapReply = useCallback(
      (ReplaceablePrivateDirectMessageData eventData) {
        final replyMessage = eventData.relatedEvents?.singleOrNull;

        if (replyMessage != null) {
          final replyMessageIndex = messages.indexWhere(
            (element) => element.sharedId == replyMessage.eventReference.dTag,
          );
          itemScrollController.scrollTo(
            index: replyMessageIndex,
            duration: const Duration(milliseconds: 300),
          );
        }
      },
      [messages, itemScrollController],
    );

    return ColoredBox(
      color: context.theme.appColors.primaryBackground,
      child: ScreenSideOffset.small(
        child: ScrollablePositionedList.builder(
          physics: const ClampingScrollPhysics(),
          itemCount: messages.length,
          itemScrollController: itemScrollController,
          reverse: true,
          itemBuilder: (context, index) {
            final currentMessageIndex = messages.length - index - 1;
            final message = messages[currentMessageIndex];

            final previousMessage =
                (currentMessageIndex == 0) ? null : messages[currentMessageIndex - 1];
            final isLastMessage = currentMessageIndex == (messages.length - 1);

            final isMessageFromAnotherAuthor =
                previousMessage != null && previousMessage.masterPubkey != message.masterPubkey;

            final eventData = ReplaceablePrivateDirectMessageData.fromEventMessage(message);
            return Column(
              mainAxisSize: MainAxisSize.min,
              key: ValueKey(message.sharedId),
              children: [
                if (previousMessage == null ||
                    previousMessage.createdAt.day != message.createdAt.day)
                  Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 12.0.s),
                      child: ChatDateHeaderText(date: message.createdAt),
                    ),
                  ),
                Padding(
                  padding: EdgeInsetsDirectional.only(
                    bottom: isLastMessage ? 20.0.s : 8.0.s,
                    top: isMessageFromAnotherAuthor ? 8.0.s : 0,
                  ),
                  child: switch (eventData.messageType) {
                    MessageType.text => TextMessage(
                        eventMessage: message,
                        onTapReply: () => onTapReply(eventData),
                      ),
                    MessageType.storyReply => StoryReplyMessage(eventMessage: message),
                    MessageType.profile => ProfileShareMessage(
                        eventMessage: message,
                        onTapReply: () => onTapReply(eventData),
                      ),
                    MessageType.visualMedia => VisualMediaMessage(
                        eventMessage: message,
                        onTapReply: () => onTapReply(eventData),
                      ),
                    MessageType.requestFunds => MoneyMessage(
                        eventMessage: message,
                        onTapReply: () => onTapReply(eventData),
                      ),
                    MessageType.emoji => EmojiMessage(
                        eventMessage: message,
                        onTapReply: () => onTapReply(eventData),
                      ),
                    MessageType.audio => AudioMessage(
                        eventMessage: message,
                        onTapReply: () => onTapReply(eventData),
                      ),
                    MessageType.document => DocumentMessage(
                        eventMessage: message,
                        onTapReply: () => onTapReply(eventData),
                      ),
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
