// SPDX-License-Identifier: ice License 1.0

import 'dart:math';

import 'package:flutter/material.dart';
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
import 'package:ion/app/features/chat/model/message_author.dart';
import 'package:ion/app/features/chat/model/message_list_item.dart';
import 'package:ion/app/features/chat/model/message_reaction_group.dart';

class ChatMessagesList extends StatelessWidget {
  const ChatMessagesList(
    this.messages, {
    super.key,
    this.displayAuthorsIncomingMessages = false,
  });

  final bool displayAuthorsIncomingMessages;
  final List<MessageListItem> messages;

  bool _isMessageFromDifferentUser(int index, MessageAuthor? currentAuthor) {
    final message = messages[index];
    if (message is MessageWithAuthor) {
      return currentAuthor != (message as MessageWithAuthor).author;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: context.theme.appColors.primaryBackground,
      child: ListView.separated(
        itemCount: messages.length,
        padding: EdgeInsets.symmetric(vertical: 12.0.s),
        itemBuilder: (context, index) {
          final message = messages[index];
          final isLastMessage = index == (messages.length - 1);
          final isFirstMessage = index <= 0;

          final author =
              message is MessageWithAuthor ? (message as MessageWithAuthor).author : null;

          final isLastMessageFromSender =
              isLastMessage || _isMessageFromDifferentUser(index + 1, author);

          MessageAuthor? authorToDisplay;
          if (displayAuthorsIncomingMessages) {
            final isFirstMessageFromSender =
                isFirstMessage || _isMessageFromDifferentUser(index - 1, author);
            authorToDisplay = isFirstMessageFromSender ? author : null;
          }

          final isMe = author?.isCurrentUser ?? false;

          final messageWidget = messages[index].map(
            date: (date) => const Center(child: ChatDateHeaderText()),
            system: (message) => SystemMessage(message: message.text),
            text: (message) => TextMessage(
              message: message.text,
              isMe: message.author.isCurrentUser,
              isLastMessageFromSender: isLastMessageFromSender,
              author: authorToDisplay,
            ),
            photo: (message) => PhotoMessage(
              isMe: isMe,
              imageUrl: message.imageUrl,
              message: message.text,
              reactions: mockReactionsMany,
              author: authorToDisplay,
              isLastMessageFromSender: isLastMessageFromSender,
            ),
            emoji: (message) => EmojiMessage(
              emoji: message.emoji,
              reactions: mockReactionsSimple,
              isMe: isMe,
              isLastMessageFromSender: isLastMessageFromSender,
              // TODO: Replace mocked implementation
              hasForwardedMessage: Random().nextBool(),
            ),
            audio: (message) => AudioMessage(
              id: message.audioId,
              audioUrl: message.audioUrl,
              isMe: isMe,
              reactions: mockReactionsMany,
              author: authorToDisplay,
              isLastMessageFromSender: isLastMessageFromSender,
            ),
            video: (message) => VideoMessage(
              isMe: isMe,
              message: message.text,
              author: authorToDisplay,
              videoUrl: message.videoUrl,
              isLastMessageFromSender: isLastMessageFromSender,
            ),
            link: (message) => UrlPreviewMessage(
              isMe: isMe,
              url: message.link,
              reactions: mockReactionsSimple,
              author: authorToDisplay,
              isLastMessageFromSender: isLastMessageFromSender,
            ),
            shareProfile: (message) => ProfileShareMessage(
              isMe: isMe,
              reactions: mockReactionsSimple,
              author: authorToDisplay,
              isLastMessageFromSender: isLastMessageFromSender,
            ),
            poll: (message) => PollMessage(
              isMe: isMe,
              reactions: mockReactionsSimple,
              author: authorToDisplay,
              isLastMessageFromSender: isLastMessageFromSender,
            ),
            money: (message) => MoneyMessage(
              isMe: isMe,
              type: message.type,
              amount: message.amount,
              equivalentUsd: message.usdt,
              chain: message.chain,
              author: authorToDisplay,
              isLastMessageFromSender: isLastMessageFromSender,
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
                      if (isLastMessageFromSender)
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
          final isLastMessageFromSender = isLastMessage ||
              _isMessageFromDifferentUser(
                index + 1,
                message is MessageWithAuthor ? (message as MessageWithAuthor).author : null,
              );

          var separatorHeight = 8.0.s;

          if (message is DateItem) {
            separatorHeight = 12.0.s;
          } else if (isLastMessageFromSender) {
            separatorHeight = 16.0.s;
          }

          return SizedBox(height: separatorHeight);
        },
      ),
    );
  }
}
