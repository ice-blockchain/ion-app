// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/chat/messages/views/components/message_item_wrapper/message_item_wrapper.dart';
import 'package:ion/app/features/chat/messages/views/components/message_metadata/message_metadata.dart';
import 'package:ion/app/features/chat/messages/views/components/message_reactions/message_reactions.dart';
import 'package:ion/app/features/chat/model/message_reaction_group.dart';

class TextMessage extends StatelessWidget {
  const TextMessage({
    required this.message,
    required this.isMe,
    required this.reactions,
    super.key,
  });
  final bool isMe;
  final String message;
  final List<MessageReactionGroup> reactions;
  @override
  Widget build(BuildContext context) {
    return MessageItemWrapper(
      contentPadding: EdgeInsets.symmetric(
        horizontal: 12.0.s,
        vertical: 12.0.s,
      ),
      isMe: isMe,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      message,
                      style: context.theme.appTextThemes.body2.copyWith(
                        color: isMe
                            ? context.theme.appColors.onPrimaryAccent
                            : context.theme.appColors.primaryText,
                      ),
                    ),
                    if (reactions.isNotEmpty) MessageReactions(reactions: reactions),
                  ],
                ),
              ),
              MessageMetaData(isMe: isMe),
            ],
          ),
        ],
      ),
    );
  }
}
