// SPDX-License-Identifier: ice License 1.0

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/chat/e2ee/model/entities/private_direct_message_data.f.dart';
import 'package:ion/app/features/chat/model/message_type.dart';
import 'package:ion/app/features/chat/providers/messaging_bottom_bar_state_provider.r.dart';
import 'package:ion/app/features/chat/views/components/message_items/components.dart';
import 'package:ion/app/features/chat/views/components/message_items/message_types/document_message/document_message.dart';
import 'package:ion/app/features/chat/views/components/message_items/message_types/post_message/post_message.dart';
import 'package:ion/app/features/chat/views/components/message_items/message_types/visual_media_message/visual_media_message.dart';
import 'package:ion/app/features/chat/views/components/scroll_to_bottom_button.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/utils/future.dart';
import 'package:super_sliver_list/super_sliver_list.dart';

class OneToOneMessageList extends HookConsumerWidget {
  const OneToOneMessageList(this.messages, {super.key});

  final Map<DateTime, List<EventMessage>> messages;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scrollController = useScrollController();
    final listController = useMemoized(ListController.new);

    final allMessages = messages.values.expand((e) => e).toList()
      ..sortByCompare((e) => e.publishedAt, (a, b) => b.compareTo(a));

    final animateToItem = useCallback(
      (int index) {
        listController.animateToItem(
          index: index,
          scrollController: scrollController,
          alignment: 0,
          duration: (d) => 300.milliseconds,
          curve: (c) => Curves.easeInOut,
        );
      },
      [scrollController, listController],
    );

    final onTapReply = useCallback(
      (ReplaceablePrivateDirectMessageEntity entity) {
        final replyMessage = entity.data.relatedEvents?.singleOrNull;

        if (replyMessage != null) {
          final replyMessageIndex = allMessages.indexWhere(
            (element) => element.sharedId == replyMessage.eventReference.dTag,
          );
          animateToItem(replyMessageIndex);
        }
      },
      [allMessages, scrollController, listController],
    );

    return NotificationListener<ScrollUpdateNotification>(
      onNotification: (notification) {
        if (notification.scrollDelta != null && notification.scrollDelta! > 0) {
          ref.invalidate(isPreviousMoreProvider);
          FocusManager.instance.primaryFocus?.unfocus();
        }
        return false;
      },
      child: Stack(
        fit: StackFit.expand,
        children: [
          ColoredBox(
            color: context.theme.appColors.primaryBackground,
            child: ScreenSideOffset.small(
              child: SuperListView.builder(
                key: const Key('one_to_one_messages_list'),
                physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                ),
                findChildIndexCallback: (key) {
                  final valueKey = key as ValueKey<String>;
                  return allMessages.indexWhere((e) => e.id == valueKey.value);
                },
                itemCount: allMessages.length,
                controller: scrollController,
                listController: listController,
                reverse: true,
                itemBuilder: (context, index) {
                  final message = allMessages[index];

                  final entity = ReplaceablePrivateDirectMessageEntity.fromEventMessage(message);

                  final displayDate = messages.entries
                      .singleWhereOrNull((entry) => entry.value.last.id == message.id)
                      ?.key;

                  final isLastMessageInConversation = index == 0;
                  final hasNextMessageFromAnotherUser =
                      index > 0 && allMessages[index - 1].masterPubkey != message.masterPubkey;

                  final margin = EdgeInsetsDirectional.only(
                    bottom: isLastMessageInConversation || hasNextMessageFromAnotherUser
                        ? 20.0.s
                        : 8.0.s,
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
          ScrollToBottomButton(
            scrollController: scrollController,
            onTap: () => animateToItem(0),
          ),
        ],
      ),
    );
  }
}
