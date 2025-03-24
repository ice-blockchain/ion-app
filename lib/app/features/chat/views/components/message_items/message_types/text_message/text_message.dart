// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/chat/views/components/message_items/message_item_wrapper/message_item_wrapper.dart';
import 'package:ion/app/features/chat/views/components/message_items/message_metadata/message_metadata.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';

class TextMessage extends HookConsumerWidget {
  const TextMessage({
    required this.eventMessage,
    this.isLastMessageFromAuthor = true,
    super.key,
  });

  final bool isLastMessageFromAuthor;
  final EventMessage eventMessage;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isMe = ref.watch(isCurrentUserSelectorProvider(eventMessage.masterPubkey));

    return MessageItemWrapper(
      messageEvent: eventMessage,
      isLastMessageFromAuthor: isLastMessageFromAuthor,
      contentPadding: EdgeInsets.symmetric(
        horizontal: 12.0.s,
        vertical: 12.0.s,
      ),
      isMe: isMe,
      child: _buildText(
        eventMessage.content,
        context.theme.appTextThemes.body2.copyWith(
          color:
              isMe ? context.theme.appColors.onPrimaryAccent : context.theme.appColors.primaryText,
        ),
      ),
    );
  }

  Widget _buildText(String message, TextStyle style) {
    final oneLineTextPainter = TextPainter(
      text: TextSpan(text: message, style: style),
      textDirection: TextDirection.ltr,
      textWidthBasis: TextWidthBasis.longestLine,
    )..layout(maxWidth: 194.0.s);

    final oneLineMetrics = oneLineTextPainter.computeLineMetrics();

    if (oneLineMetrics.isEmpty) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            message,
            style: style,
          ),
          MessageMetaData(eventMessage: eventMessage),
        ],
      );
    }

    if (oneLineMetrics.length == 1) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            message,
            style: style,
          ),
          MessageMetaData(eventMessage: eventMessage),
        ],
      );
    } else {
      final multiLineTextPainter = TextPainter(
        text: TextSpan(text: message, style: style),
        textDirection: TextDirection.ltr,
        textWidthBasis: TextWidthBasis.longestLine,
      )..layout(maxWidth: 240.0.s);

      final lineMetrics = multiLineTextPainter.computeLineMetrics();

      final lastLineWidth = lineMetrics.last.width;

      final bool wouldOverlap;

      wouldOverlap = lastLineWidth > 170.0.s;

      return Stack(
        alignment: Alignment.bottomRight,
        children: [
          Text(
            '$message${wouldOverlap ? '\n' : ''}',
            style: style,
          ),
          MessageMetaData(eventMessage: eventMessage),
        ],
      );
    }
  }
}
