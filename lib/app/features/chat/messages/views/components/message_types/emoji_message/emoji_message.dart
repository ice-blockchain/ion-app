// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/chat/messages/views/components/message_item_wrapper/message_item_wrapper.dart';
import 'package:ion/app/features/chat/messages/views/components/message_metadata/message_metadata.dart';

class EmojiMessage extends StatelessWidget {
  const EmojiMessage({required this.emoji, required this.isMe, super.key});
  final bool isMe;
  final String emoji;

  @override
  Widget build(BuildContext context) {
    return MessageItemWrapper(
      isMe: isMe,
      contentPadding: EdgeInsets.symmetric(
        horizontal: 12.0.s,
        vertical: 6.0.s,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            emoji,
            style: context.theme.appTextThemes.headline1.copyWith(height: 1),
          ),
          MessageMetaData(isMe: isMe),
        ],
      ),
    );
  }
}
