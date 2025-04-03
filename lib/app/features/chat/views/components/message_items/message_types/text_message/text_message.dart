// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/chat/model/message_list_item.c.dart';
import 'package:ion/app/features/chat/views/components/message_items/message_item_wrapper/message_item_wrapper.dart';
import 'package:ion/app/features/chat/views/components/message_items/message_metadata/message_metadata.dart';
import 'package:ion/app/features/chat/views/components/message_items/message_reactions/message_reactions.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';

class TextMessage extends ConsumerWidget {
  const TextMessage({
    required this.eventMessage,
    super.key,
  });

  final EventMessage eventMessage;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isMe = ref.watch(isCurrentUserSelectorProvider(eventMessage.masterPubkey));

    final textStyle = context.theme.appTextThemes.body2.copyWith(
        color:
            isMe ? context.theme.appColors.onPrimaryAccent : context.theme.appColors.primaryText);

    final oneLineTextPainter = TextPainter(
      text: TextSpan(
        text: eventMessage.content,
        style: textStyle,
      ),
      textDirection: TextDirection.ltr,
      textWidthBasis: TextWidthBasis.longestLine,
    )..layout(maxWidth: 194.0.s);

    final oneLineMetrics = oneLineTextPainter.computeLineMetrics();
    final multiline = oneLineMetrics.length > 1;

    return MessageItemWrapper(
      isMe: isMe,
      messageItem: TextItem(
        multiline: multiline,
        eventMessage: eventMessage,
        contentDescription: eventMessage.content,
      ),
      contentPadding: EdgeInsets.symmetric(
        horizontal: 12.0.s,
        vertical: 12.0.s,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _TextMessageContent(
            multiline: multiline,
            textStyle: textStyle,
            eventMessage: eventMessage,
          ),
          MessageReactions(isMe: isMe, eventMessage: eventMessage),
        ],
      ),
    );
  }
}

class _TextMessageContent extends StatelessWidget {
  const _TextMessageContent({
    required this.textStyle,
    required this.multiline,
    required this.eventMessage,
  });

  final bool multiline;
  final TextStyle textStyle;
  final EventMessage eventMessage;

  @override
  Widget build(BuildContext context) {
    if (!multiline) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(eventMessage.content, style: textStyle),
        ],
      );
    } else {
      final multiLineTextPainter = TextPainter(
        text: TextSpan(text: eventMessage.content, style: textStyle),
        textDirection: TextDirection.ltr,
        textWidthBasis: TextWidthBasis.longestLine,
      )..layout(maxWidth: 240.0.s);

      final lineMetrics = multiLineTextPainter.computeLineMetrics();
      final wouldOverlap = lineMetrics.last.width > 200.0.s;

      return Stack(
        alignment: AlignmentDirectional.bottomEnd,
        children: [
          Text(
            '${eventMessage.content}${wouldOverlap ? '\n' : ''}',
            style: textStyle,
          ),
          MessageMetaData(eventMessage: eventMessage),
        ],
      );
    }
  }
}
