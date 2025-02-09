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

class ChatMessagesList extends HookConsumerWidget {
  const ChatMessagesList(
    this.messages, {
    super.key,
    this.displayAuthorsIncomingMessages = false,
  });

  final bool displayAuthorsIncomingMessages;
  final Map<DateTime, List<EventMessage>> messages;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scrollController = useScrollController();

    useOnInit(() => scrollController.jumpTo(scrollController.position.maxScrollExtent));

    return ColoredBox(
      color: context.theme.appColors.primaryBackground,
      child: ScreenSideOffset.small(
        child: ListView.builder(
          controller: scrollController,
          itemCount: messages.entries.length,
          itemBuilder: (context, index) {
            final date = messages.entries.toList()[index].key;
            final messagesForDate = messages.entries.toList()[index].value;

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.0.s),
                  child: ChatDateHeaderText(date: date),
                ),
                ListView.separated(
                  //TODO: use sliver list to improve performance
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: messagesForDate.length,
                  separatorBuilder: (context, index) => SizedBox(height: 8.0.s),
                  itemBuilder: (context, msgIndex) {
                    final message = messagesForDate[msgIndex];

                    return TextMessage(
                      eventMessage: message,
                    );
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
