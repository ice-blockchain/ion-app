// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/text_span_builder/hooks/use_text_span_builder.dart';
import 'package:ion/app/components/text_span_builder/text_span_builder.dart';
import 'package:ion/app/components/url_preview/providers/url_metadata_provider.c.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/chat/hooks/use_has_reaction.dart';
import 'package:ion/app/features/chat/model/message_list_item.c.dart';
import 'package:ion/app/features/chat/recent_chats/providers/replied_message_list_item_provider.c.dart';
import 'package:ion/app/features/chat/views/components/message_items/components.dart';
import 'package:ion/app/features/chat/views/components/message_items/message_reactions/message_reactions.dart';
import 'package:ion/app/features/chat/views/components/message_items/message_types/reply_message/reply_message.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/services/text_parser/model/text_matcher.dart';
import 'package:ion/app/services/text_parser/text_parser.dart';

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

    final firstUrl = RegExp(const UrlMatcher().pattern).firstMatch(eventMessage.content)?.group(0);

    final metadata = firstUrl != null ? ref.watch(urlMetadataProvider(firstUrl)) : null;

    final hasReactionsOrMetadata = useHasReaction(eventMessage, ref) || metadata != null;

    final messageItem = TextItem(
      eventMessage: eventMessage,
      contentDescription: eventMessage.content,
    );

    final repliedEventMessage = ref.watch(repliedMessageListItemProvider(messageItem));

    final repliedMessageItem = getRepliedMessageListItem(
      ref: ref,
      repliedEventMessage: repliedEventMessage.valueOrNull,
    );

    return MessageItemWrapper(
      isMe: isMe,
      messageItem: messageItem,
      contentPadding: EdgeInsets.symmetric(
        horizontal: 12.0.s,
        vertical: 12.0.s,
      ),
      child: IntrinsicWidth(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (repliedMessageItem != null) ReplyMessage(messageItem, repliedMessageItem),
            _TextMessageContent(
              textStyle: textStyle,
              eventMessage: eventMessage,
              hasReactionsOrMetadata: hasReactionsOrMetadata,
              hasRepliedMessage: repliedMessageItem != null,
            ),
            if (metadata != null)
              IntrinsicHeight(
                child: UrlPreviewBlock(
                  url: firstUrl!,
                  isMe: isMe,
                ),
              ),
            if (hasReactionsOrMetadata)
              Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: MessageReactions(isMe: isMe, eventMessage: eventMessage),
                  ),
                  MessageMetaData(eventMessage: eventMessage, startPadding: 0.0.s),
                ],
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
    required this.hasReactionsOrMetadata,
    required this.hasRepliedMessage,
  });

  final TextStyle textStyle;
  final EventMessage eventMessage;
  final bool hasReactionsOrMetadata;
  final bool hasRepliedMessage;
  @override
  Widget build(BuildContext context) {
    final maxAvailableWidth = MessageItemWrapper.maxWidth - (12.0.s * 2) - 32.0.s;
    final content = eventMessage.content;

    final metadataRef = useRef(GlobalKey());

    final metadataWidth = useState<double>(0);

    useEffect(
      () {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          final box = metadataRef.value.currentContext?.findRenderObject() as RenderBox?;
          if (box != null && box.hasSize && box.size.width > 0) {
            metadataWidth.value = box.size.width;
          }
        });
        return null;
      },
      [eventMessage],
    );

    final oneLineTextPainter = TextPainter(
      text: TextSpan(
        text: content,
        style: textStyle,
      ),
      textDirection: TextDirection.ltr,
      textWidthBasis: TextWidthBasis.longestLine,
    )..layout(maxWidth: maxAvailableWidth - metadataWidth.value.s);

    final oneLineMetrics = oneLineTextPainter.computeLineMetrics();
    final multiline = oneLineMetrics.length > 1;

    if (hasReactionsOrMetadata) {
      return _TextRichContent(text: content, textStyle: textStyle);
    }
    if (!multiline) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _TextRichContent(text: content, textStyle: textStyle),
          if (hasRepliedMessage) const Spacer(),
          MessageMetaData(eventMessage: eventMessage, key: metadataRef.value),
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
          _TextRichContent(text: wouldOverlap ? '$content\n' : content, textStyle: textStyle),
          MessageMetaData(eventMessage: eventMessage, key: metadataRef.value),
        ],
      );
    }
  }
}

class _TextRichContent extends HookWidget {
  const _TextRichContent({
    required this.textStyle,
    required this.text,
  });

  final TextStyle textStyle;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      useTextSpanBuilder(
        context,
        defaultStyle: textStyle,
        matcherStyles: {
          const UrlMatcher(): textStyle.copyWith(
            decoration: TextDecoration.underline,
            decorationColor: textStyle.color,
          ),
        },
      ).build(
        TextParser(matchers: {const UrlMatcher()}).parse(text),
        onTap: (match) => TextSpanBuilder.defaultOnTap(context, match: match),
      ),
    );
  }
}
