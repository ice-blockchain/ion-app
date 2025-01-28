// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/chat/messages/views/components/message_author/message_author.dart';
import 'package:ion/app/features/chat/messages/views/components/message_item_wrapper/message_item_wrapper.dart';
import 'package:ion/app/features/chat/messages/views/components/message_metadata/message_metadata.dart';
import 'package:ion/app/features/chat/messages/views/components/message_reactions/message_reactions.dart';
import 'package:ion/app/features/chat/messages/views/components/replied_message_info/replied_message_info.dart';
import 'package:ion/app/features/chat/model/message_author.c.dart';
import 'package:ion/app/features/chat/model/message_reaction_group.c.dart';
import 'package:ion/app/features/chat/model/replied_message.c.dart';

class TextMessage extends StatelessWidget {
  const TextMessage({
    required this.isMe,
    required this.message,
    required this.createdAt,
    this.isLastMessageFromAuthor = true,
    this.reactions = const [],
    this.author,
    this.repliedMessage,
    super.key,
  });

  final bool isMe;
  final String message;
  final DateTime createdAt;
  final MessageAuthor? author;
  final bool isLastMessageFromAuthor;
  final RepliedMessage? repliedMessage;
  final List<MessageReactionGroup> reactions;

  @override
  Widget build(BuildContext context) {
    return MessageItemWrapper(
      isLastMessageFromAuthor: isLastMessageFromAuthor,
      contentPadding: EdgeInsets.symmetric(
        horizontal: 12.0.s,
        vertical: 12.0.s,
      ),
      isMe: isMe,
      child: IntrinsicWidth(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MessageAuthorNameWidget(author: author),
            if (repliedMessage case final RepliedMessage replied)
              RepliedMessageInfo(
                isMe: isMe,
                sender: replied.author,
                message: replied.message,
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        message,
                        style: context.theme.appTextThemes.body2.copyWith(
                          color: isMe ? context.theme.appColors.onPrimaryAccent : context.theme.appColors.primaryText,
                        ),
                      ),
                      if (reactions.isNotEmpty) MessageReactions(reactions: reactions),
                    ],
                  ),
                ),
                MessageMetaData(isMe: isMe, createdAt: createdAt),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
