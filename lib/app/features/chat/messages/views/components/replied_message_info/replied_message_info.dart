// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/chat/model/message_author.dart';
import 'package:ion/app/features/chat/providers/mock.dart';
import 'package:ion/app/features/chat/recent_chats/views/components/recent_chat_tile/recent_chat_tile.dart';

class RepliedMessageInfo extends HookWidget {
  const RepliedMessageInfo({
    required this.isMe,
    required this.sender,
    required this.message,
    super.key,
  });

  final bool isMe;
  final MessageAuthor sender;
  final RecentChatMessage message;

  @override
  Widget build(BuildContext context) {
    final bgColor = useMemoized(
      () => isMe ? context.theme.appColors.darkBlue : context.theme.appColors.primaryBackground,
      [isMe],
    );

    final textColor = useMemoized(
      () => isMe ? context.theme.appColors.onPrimaryAccent : null,
      [isMe],
    );

    return IntrinsicWidth(
      child: Container(
        padding: EdgeInsets.fromLTRB(6.0.s, 4.0.s, 8.0.s, 4.0.s),
        margin: EdgeInsets.only(bottom: 12.0.s),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(10.0.s),
        ),
        child: IntrinsicHeight(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _SideVerticalDivider(isMe: isMe),
              Flexible(
                child: Column(
                  children: [
                    SenderSummary(sender: sender, textColor: textColor),
                    ChatPreview(message: message, textColor: textColor, maxLines: 1),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SideVerticalDivider extends StatelessWidget {
  const _SideVerticalDivider({
    required this.isMe,
  });

  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 2.0.s,
      margin: EdgeInsets.only(right: 6.0.s),
      decoration: BoxDecoration(
        color:
            isMe ? context.theme.appColors.onPrimaryAccent : context.theme.appColors.primaryAccent,
        borderRadius: BorderRadius.circular(2.0.s),
      ),
    );
  }
}
