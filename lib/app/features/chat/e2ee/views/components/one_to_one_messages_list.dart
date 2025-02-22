// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/chat/e2ee/model/entites/private_direct_message_data.c.dart';
import 'package:ion/app/features/chat/views/components/message_items/chat_date_header_text/chat_date_header_text.dart';
import 'package:ion/app/features/chat/views/components/message_items/message_types/text_message/text_message.dart';
import 'package:ion/app/features/chat/views/components/message_items/message_types/video_message/video_message.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';

class OneToOneMessageList extends HookConsumerWidget {
  const OneToOneMessageList(
    this.messages, {
    super.key,
    this.displayAuthorsIncomingMessages = false,
  });

  final bool displayAuthorsIncomingMessages;
  final Map<DateTime, List<EventMessage>> messages;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scrollController = useScrollController();

    return ColoredBox(
      color: context.theme.appColors.primaryBackground,
      child: ScreenSideOffset.small(
        child: CustomScrollView(
          controller: scrollController,
          reverse: true,
          slivers: [
            for (final entry in messages.entries) ...[
              SliverList(
                key: ValueKey(entry.key),
                delegate: SliverChildBuilderDelegate(
                  (context, msgIndex) {
                    final message = entry.value[msgIndex];
                    final entity = PrivateDirectMessageEntity.fromEventMessage(message);
                    final previousMessage = msgIndex > 0 ? entry.value[msgIndex - 1] : null;
                    final isLastMessage = msgIndex == entry.value.length - 1;

                    final isLastMessageFromAuthor =
                        previousMessage == null || previousMessage.pubkey == message.pubkey;

                    return Padding(
                      padding: EdgeInsets.only(
                        bottom: isLastMessage
                            ? 20.0.s
                            : isLastMessageFromAuthor
                                ? 8.0.s
                                : 12.0.s,
                      ),
                      child: switch (entity.data.messageType) {
                        MessageType.text =>
                          TextMessage(eventMessage: message, key: ValueKey(message.id)),
                        MessageType.video =>
                          VideoMessage(eventMessage: message, key: ValueKey(message.id)),
                      },
                    );
                  },
                  childCount: entry.value.length,
                ),
              ),
              SliverToBoxAdapter(
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 12.0.s),
                    child: ChatDateHeaderText(date: entry.key),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // Widget _buildMessage(EventMessage message) {
  //   final entity = PrivateDirectMessageEntity.fromEventMessage(message);

  //   switch (entity.data.messageType) {
  //     case MessageType.text:
  //       return TextMessage(eventMessage: message, key: ValueKey(message.id));
  //     case MessageType.video:
  //       return VideoMessage(eventMessage: message, key: ValueKey(message.id));
  //   }
  // }

  // bool _shouldRenderDateHeader(int index, List<EventMessage> messages) {
  //   final message = messages[index];

  //   // Extract current message's date (ignores time)
  //   final currentMessageDate = DateTime(
  //     message.createdAt.year,
  //     message.createdAt.month,
  //     message.createdAt.day,
  //   );

  //   var renderDateHeader =
  //       index == messages.length - 1; // First item from bottom should always have a header

  //   if (index < messages.length - 1) {
  //     final nextMessage = messages[index + 1];

  //     // Extract next message's date (ignores time)
  //     final nextMessageDate = DateTime(
  //       nextMessage.createdAt.year,
  //       nextMessage.createdAt.month,
  //       nextMessage.createdAt.day,
  //     );

  //     renderDateHeader = currentMessageDate != nextMessageDate;
  //   }

  //   return renderDateHeader;
  // }
}
