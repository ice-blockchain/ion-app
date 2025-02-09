// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/chat/model/message_author.c.dart';
import 'package:ion/app/features/chat/model/message_reaction_group.c.dart';
import 'package:ion/app/features/chat/views/components/message_items/forwarded_message_info/forwarded_message_info.dart';
import 'package:ion/app/features/chat/views/components/message_items/message_author/message_author.dart';
import 'package:ion/app/features/chat/views/components/message_items/message_item_wrapper/message_item_wrapper.dart';
import 'package:ion/app/features/chat/views/components/message_items/message_reactions/message_reactions.dart';

class EmojiMessage extends StatelessWidget {
  const EmojiMessage({
    required this.emoji,
    required this.isMe,
    required this.createdAt,
    this.author,
    this.reactions,
    this.hasForwardedMessage = false,
    this.isLastMessageFromAuthor = true,
    super.key,
  });
  final bool isMe;
  final String emoji;
  final DateTime createdAt;
  final List<MessageReactionGroup>? reactions;
  final bool isLastMessageFromAuthor;
  final bool hasForwardedMessage;
  final MessageAuthor? author;

  @override
  Widget build(BuildContext context) {
    return MessageItemWrapper(
      isMe: isMe,
      isLastMessageFromAuthor: isLastMessageFromAuthor,
      contentPadding: EdgeInsets.symmetric(
        horizontal: 12.0.s,
        vertical: 6.0.s,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MessageAuthorNameWidget(author: author),
          Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: (reactions != null || hasForwardedMessage)
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (hasForwardedMessage) ForwardedMessageInfo(isMe: isMe, isPublic: true),
                  Text(
                    emoji,
                    style: context.theme.appTextThemes.headline1.copyWith(height: 1),
                  ),
                  MessageReactions(reactions: reactions),
                ],
              ),
              // MessageMetaData(isMe: isMe, createdAt: createdAt),
            ],
          ),
        ],
      ),
    );
  }
}
