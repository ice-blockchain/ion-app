// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/chat/model/database/chat_database.c.dart';
import 'package:ion/app/features/chat/model/message_list_item.c.dart';
import 'package:ion/app/features/chat/views/components/message_items/message_item_wrapper/message_item_wrapper.dart';
import 'package:ion/app/features/chat/views/components/message_items/message_metadata/message_metadata.dart';
import 'package:ion/app/features/chat/views/components/message_items/message_reactions/message_reactions.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';

class TextMessage extends HookConsumerWidget {
  const TextMessage({
    required this.eventMessage,
    super.key,
  });

  final EventMessage eventMessage;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isMe = ref.watch(isCurrentUserSelectorProvider(eventMessage.masterPubkey));

    final textStyle = context.theme.appTextThemes.body2.copyWith(
      color: isMe ? context.theme.appColors.onPrimaryAccent : context.theme.appColors.primaryText,
    );

    final reactionsStream = useMemoized(
      () => ref.watch(conversationMessageReactionDaoProvider).messageReactions(eventMessage),
      [eventMessage],
    );

    final hasReactions = useStream(reactionsStream).data?.isNotEmpty ?? false;

    print('hasReactions: $hasReactions');

    return IntrinsicWidth(
      child: MessageItemWrapper(
        isMe: isMe,
        messageItem: TextItem(
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
              textStyle: textStyle,
              eventMessage: eventMessage,
              hasReactions: hasReactions,
            ),
            if (hasReactions)
              IntrinsicWidth(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Flexible(
                        child: MessageReactions(isMe: isMe, eventMessage: eventMessage),
                      ),
                      MessageMetaData(eventMessage: eventMessage),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _TextMessageContent extends HookWidget {
  const _TextMessageContent({
    required this.textStyle,
    required this.eventMessage,
    required this.hasReactions,
  });

  final TextStyle textStyle;
  final EventMessage eventMessage;
  final bool hasReactions;
  @override
  Widget build(BuildContext context) {
    final maxAvailableWidth = MessageItemWrapper.maxWidth - (12.0.s * 2) - 32.0.s;
    const content = 'a a a a  a a a a a a a a a a';

    final oneLineTextPainter = TextPainter(
      text: TextSpan(
        text: content,
        style: textStyle,
      ),
      textDirection: TextDirection.ltr,
      textWidthBasis: TextWidthBasis.longestLine,
    )..layout(maxWidth: maxAvailableWidth);

    final oneLineMetrics = oneLineTextPainter.computeLineMetrics();
    final multiline = oneLineMetrics.length > 1;

    if (hasReactions) {
      return Text(content, style: textStyle);
    }
    if (!multiline) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(content, style: textStyle),
          MessageMetaData(eventMessage: eventMessage),
        ],
      );
    } else {
      final multiLineTextPainter = TextPainter(
        text: TextSpan(text: content, style: textStyle),
        textDirection: TextDirection.ltr,
        textWidthBasis: TextWidthBasis.longestLine,
      )..layout(maxWidth: maxAvailableWidth);

      final lineMetrics = multiLineTextPainter.computeLineMetrics();
      final wouldOverlap = lineMetrics.last.width > 184.0.s;

      return Stack(
        alignment: AlignmentDirectional.bottomEnd,
        children: [
          Text(
            '$content${wouldOverlap ? '\n' : ''}',
            style: textStyle,
          ),
          MessageMetaData(eventMessage: eventMessage),
        ],
      );
    }
  }
}
