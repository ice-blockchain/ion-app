// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
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

    return MessageItemWrapper(
      isMe: isMe,
      contentPadding: EdgeInsets.symmetric(
        vertical: 12.0.s,
        horizontal: 12.0.s,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _TextMessageContent(
            style: context.theme.appTextThemes.body2.copyWith(
              color: isMe
                  ? context.theme.appColors.onPrimaryAccent
                  : context.theme.appColors.primaryText,
            ),
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
    required this.style,
    required this.eventMessage,
  });

  final TextStyle style;
  final EventMessage eventMessage;
  @override
  Widget build(BuildContext context) {
    final oneLineTextPainter = TextPainter(
      text: TextSpan(text: eventMessage.content, style: style),
      textDirection: TextDirection.ltr,
      textWidthBasis: TextWidthBasis.longestLine,
    )..layout(maxWidth: 194.0.s);

    final oneLineMetrics = oneLineTextPainter.computeLineMetrics();

    if (oneLineMetrics.length <= 1) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            eventMessage.content,
            style: style,
          ),
          MessageMetaData(eventMessage: eventMessage),
        ],
      );
    } else {
      final multiLineTextPainter = TextPainter(
        text: TextSpan(text: eventMessage.content, style: style),
        textDirection: TextDirection.ltr,
        textWidthBasis: TextWidthBasis.longestLine,
      )..layout(maxWidth: 240.0.s);

      final lineMetrics = multiLineTextPainter.computeLineMetrics();
      final wouldOverlap = lineMetrics.last.width > 200.0.s;

      return Stack(
        alignment: Alignment.bottomRight,
        children: [
          Text(
            '${eventMessage.content}${wouldOverlap ? '\n' : ''}',
            style: style,
          ),
          MessageMetaData(eventMessage: eventMessage),
        ],
      );
    }
  }
}
