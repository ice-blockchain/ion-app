// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/chat/views/components/message_items/chat_date_header_text/chat_date_header_text.dart';
import 'package:ion/app/features/chat/views/components/message_items/message_types/text_message/text_message.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/hooks/use_on_init.dart';

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

    useOnInit(
      () {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      },
      [messages],
    );

    return ColoredBox(
      color: context.theme.appColors.primaryBackground,
      child: ScreenSideOffset.small(
        child: CustomScrollView(
          controller: scrollController,
          slivers: [
            for (final entry in messages.entries) ...[
              SliverToBoxAdapter(
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 12.0.s),
                    child: ChatDateHeaderText(date: entry.key),
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, msgIndex) {
                    final message = entry.value[msgIndex];
                    if (message.content.isEmpty) {
                      return const SizedBox.shrink();
                    }
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
                      child: TextMessage(eventMessage: message),
                    );
                  },
                  childCount: entry.value.length,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
