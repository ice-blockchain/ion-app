// SPDX-License-Identifier: ice License 1.0

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/avatar/avatar.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/chat/messages/views/components/chat_date_header_text/chat_date_header_text.dart';
import 'package:ion/app/features/chat/messages/views/components/message_types/audio_message/audio_message.dart';
import 'package:ion/app/features/chat/messages/views/components/message_types/emoji_message/emoji_message.dart';
import 'package:ion/app/features/chat/messages/views/components/message_types/money_message/money_message.dart';
import 'package:ion/app/features/chat/messages/views/components/message_types/photo_message/photo_message.dart';
import 'package:ion/app/features/chat/messages/views/components/message_types/poll_message/poll_message.dart';
import 'package:ion/app/features/chat/messages/views/components/message_types/profile_share_message/profile_share_message.dart';
import 'package:ion/app/features/chat/messages/views/components/message_types/system_message/system_message.dart';
import 'package:ion/app/features/chat/messages/views/components/message_types/text_message/text_message.dart';
import 'package:ion/app/features/chat/messages/views/components/message_types/url_preview_message/url_preview_message.dart';
import 'package:ion/app/features/chat/messages/views/components/message_types/video_message/video_message.dart';
import 'package:ion/app/features/chat/model/message_list_item.c.dart';
import 'package:ion/app/features/chat/model/message_reaction_group.c.dart';
import 'package:ion/app/features/chat/providers/author_to_display_provider.c.dart';
import 'package:ion/app/hooks/use_on_init.dart';

class ChatMessagesList extends HookConsumerWidget {
  const ChatMessagesList(
    this.messages, {
    super.key,
    this.displayAuthorsIncomingMessages = false,
  });

  final bool displayAuthorsIncomingMessages;
  final List<MessageListItem> messages;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authorToDisplayProvider = ref.watch(
      authorsToDisplayProviderProvider(messages).notifier,
    );

    final scrollController = useScrollController();

    useOnInit(() => scrollController.jumpTo(scrollController.position.maxScrollExtent));

    return ColoredBox(
      color: context.theme.appColors.primaryBackground,
      child: ListView.separated(
        itemCount: messages.length,
        controller: scrollController,
        padding: EdgeInsets.symmetric(vertical: 12.0.s),
        itemBuilder: (context, index) {
          final message = messages[index];
          final isLastMessage = index == (messages.length - 1);
          final author = message is MessageWithAuthor ? (message as MessageWithAuthor).author : null;

          final isLastMessageFromAuthor = isLastMessage ||
              authorToDisplayProvider.isMessageFromDifferentUser(
                index + 1,
                author,
              );

          final authorToDisplay =
              displayAuthorsIncomingMessages ? authorToDisplayProvider.getAuthorToDisplay(index) : null;

          final isMe = author?.isCurrentUser ?? false;

          final messageWidget = messages[index].map(
            date: (date) => const Center(child: ChatDateHeaderText()),
            system: (message) => SystemMessage(message: message.text),
            text: (message) => TextMessage(
              message: message.text,
              createdAt: message.time,
              isMe: message.author.isCurrentUser,
              repliedMessage: message.repliedMessage,
              isLastMessageFromAuthor: isLastMessageFromAuthor,
              author: authorToDisplay,
            ),
            photo: (message) => PhotoMessage(
              isMe: isMe,
              createdAt: message.time,
              imageUrl: message.imageUrl,
              message: message.text,
              reactions: mockReactionsMany,
              author: authorToDisplay,
              isLastMessageFromAuthor: isLastMessageFromAuthor,
            ),
            emoji: (message) => EmojiMessage(
              emoji: message.emoji,
              createdAt: message.time,
              reactions: mockReactionsSimple,
              isMe: isMe,
              isLastMessageFromAuthor: isLastMessageFromAuthor,
              // TODO: Replace mocked implementation
              hasForwardedMessage: Random().nextBool(),
            ),
            audio: (message) => AudioMessage(
              id: message.audioId,
              createdAt: message.time,
              audioUrl: message.audioUrl,
              isMe: isMe,
              reactions: mockReactionsMany,
              author: authorToDisplay,
              isLastMessageFromAuthor: isLastMessageFromAuthor,
            ),
            video: (message) => VideoMessage(
              isMe: isMe,
              message: message.text,
              createdAt: message.time,
              author: authorToDisplay,
              videoUrl: message.videoUrl,
              isLastMessageFromAuthor: isLastMessageFromAuthor,
            ),
            link: (message) => UrlPreviewMessage(
              isMe: isMe,
              url: message.link,
              createdAt: message.time,
              reactions: mockReactionsSimple,
              author: authorToDisplay,
              isLastMessageFromAuthor: isLastMessageFromAuthor,
            ),
            shareProfile: (message) => ProfileShareMessage(
              isMe: isMe,
              createdAt: message.time,
              reactions: mockReactionsSimple,
              author: authorToDisplay,
              isLastMessageFromAuthor: isLastMessageFromAuthor,
            ),
            poll: (message) => PollMessage(
              isMe: isMe,
              createdAt: message.time,
              reactions: mockReactionsSimple,
              author: authorToDisplay,
              isLastMessageFromAuthor: isLastMessageFromAuthor,
            ),
            money: (message) => MoneyMessage(
              isMe: isMe,
              createdAt: message.time,
              type: message.type,
              amount: message.amount,
              equivalentUsd: message.usdt,
              chain: message.chain,
              author: authorToDisplay,
              isLastMessageFromAuthor: isLastMessageFromAuthor,
            ),
            // TODO: Unimplemented type
            document: (message) => throw UnimplementedError(),
          );

          return ScreenSideOffset.small(
            child: displayAuthorsIncomingMessages && author != null && !author.isCurrentUser
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      if (isLastMessageFromAuthor)
                        Avatar(size: 36.0.s, imageUrl: author.imageUrl)
                      else
                        SizedBox(width: 36.0.s),
                      SizedBox(width: 8.0.s),
                      messageWidget,
                    ],
                  )
                : messageWidget,
          );
        },
        separatorBuilder: (context, index) {
          final message = messages[index];
          final isLastMessage = index == (messages.length - 1);
          final isLastMessageFromAuthor = isLastMessage ||
              authorToDisplayProvider.isMessageFromDifferentUser(
                index + 1,
                message is MessageWithAuthor ? (message as MessageWithAuthor).author : null,
              );

          var separatorHeight = 8.0.s;

          if (message is DateItem) {
            separatorHeight = 12.0.s;
          } else if (isLastMessageFromAuthor) {
            separatorHeight = 16.0.s;
          }

          return SizedBox(height: separatorHeight);
        },
      ),
    );
  }
}
