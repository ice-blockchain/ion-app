// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/chat/messages/views/components/mesage_timestamp/mesage_timestamp.dart';
import 'package:ion/app/features/chat/messages/views/components/message_item_wrapper/message_item_wrapper.dart';

class TextMessage extends StatelessWidget {
  const TextMessage({required this.message, required this.isMe, super.key});
  final bool isMe;
  final String message;

  @override
  Widget build(BuildContext context) {
    return MessageItemWrapper(
      contentPadding: EdgeInsets.symmetric(
        horizontal: 12.0.s,
        vertical: 12.0.s,
      ),
      isMe: isMe,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              message,
              style: context.theme.appTextThemes.body2.copyWith(
                color: isMe
                    ? context.theme.appColors.onPrimaryAccent
                    : context.theme.appColors.primaryText,
              ),
            ),
          ),
          MessageTimeStamp(isMe: isMe),
        ],
      ),
    );
  }
}
