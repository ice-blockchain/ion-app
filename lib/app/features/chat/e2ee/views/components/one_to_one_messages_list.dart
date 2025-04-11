// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/chat/e2ee/model/entities/private_direct_message_data.c.dart';
import 'package:ion/app/features/chat/model/message_type.dart';
import 'package:ion/app/features/chat/views/components/message_items/components.dart';
import 'package:ion/app/features/chat/views/components/message_items/message_types/document_message/document_message.dart';
import 'package:ion/app/features/chat/views/components/message_items/message_types/visual_media_message/visual_media_message.dart';
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
          physics: const ClampingScrollPhysics(),
          reverse: true,
          slivers: [
            for (final entry in messages.entries) ...[
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  findChildIndexCallback: (key) {
                    final valueKey = key as ValueKey<String>;
                    return entry.value.indexWhere((e) => e.id == valueKey.value);
                  },
                  (context, msgIndex) {
                    final message = entry.value[msgIndex];
                    final entity = PrivateDirectMessageEntity.fromEventMessage(message);
                    final previousMessage = msgIndex > 0 ? entry.value[msgIndex - 1] : null;
                    final isLastMessage = msgIndex == entry.value.length - 1;

                    final isLastMessageFromAuthor =
                        previousMessage == null || previousMessage.pubkey == message.pubkey;

                    return Padding(
                      key: ValueKey(message.id),
                      padding: EdgeInsetsDirectional.only(
                        bottom: isLastMessage
                            ? 20.0.s
                            : isLastMessageFromAuthor
                                ? 8.0.s
                                : 12.0.s,
                      ),
                      child: switch (entity.data.messageType) {
                        MessageType.text => TextMessage(eventMessage: message),
                        MessageType.emoji => EmojiMessage(eventMessage: message),
                        MessageType.audio => AudioMessage(eventMessage: message),
                        MessageType.profile => ProfileShareMessage(eventMessage: message),
                        MessageType.document => DocumentMessage(eventMessage: message),
                        MessageType.visualMedia => VisualMediaMessage(eventMessage: message),
                        MessageType.requestFunds => MoneyMessage(eventMessage: message),
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
}
