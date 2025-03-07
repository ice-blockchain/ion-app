// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:intl/intl.dart';
import 'package:ion/app/components/button/button.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/chat/model/message_author.c.dart';
import 'package:ion/app/features/chat/model/message_reaction_group.c.dart';
import 'package:ion/app/features/chat/model/money_message_type.dart';
import 'package:ion/app/features/chat/views/components/message_items/message_author/message_author.dart';
import 'package:ion/app/features/chat/views/components/message_items/message_item_wrapper/message_item_wrapper.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/utils/num.dart';
import 'package:ion/generated/assets.gen.dart';

part 'components/amount_display.dart';

class MoneyMessage extends HookWidget {
  const MoneyMessage({
    required this.isMe,
    required this.type,
    required this.amount,
    required this.equivalentUsd,
    required this.chain,
    required this.createdAt,
    required this.eventMessage,
    this.isLastMessageFromAuthor = true,
    this.author,
    this.reactions,
    super.key,
  });

  final bool isMe;
  final MoneyMessageType type;
  final double amount;
  final double equivalentUsd;
  final String chain;
  final DateTime createdAt;
  final MessageAuthor? author;
  final EventMessage eventMessage;
  final bool isLastMessageFromAuthor;
  final List<MessageReactionGroup>? reactions;

  @override
  Widget build(BuildContext context) {
    final textColor = useMemoized(
      () => isMe ? context.theme.appColors.onPrimaryAccent : context.theme.appColors.primaryText,
      [isMe],
    );

    final title = useMemoized(
      () => type == MoneyMessageType.receive
          ? context.i18n.chat_money_received_title
          : context.i18n.chat_money_request_title,
      [type],
    );

    final buttonLabel = useMemoized(
      () => type == MoneyMessageType.receive
          ? context.i18n.chat_money_received_button
          : context.i18n.button_send,
      [type],
    );

    final buttonType = useMemoized(
      () => type == MoneyMessageType.receive
          ? (isMe ? ButtonType.primary : ButtonType.outlined)
          : (isMe ? ButtonType.secondary : ButtonType.primary),
      [type, isMe],
    );

    final buttonBackgroundColor = useMemoized(
      () => type == MoneyMessageType.receive
          ? (isMe ? context.theme.appColors.darkBlue : context.theme.appColors.tertararyBackground)
          : (isMe
              ? context.theme.appColors.secondaryBackground
              : context.theme.appColors.primaryAccent),
      [isMe],
    );

    final buttonTextColor = useMemoized(
      () => type == MoneyMessageType.receive
          ? (isMe ? context.theme.appColors.onPrimaryAccent : context.theme.appColors.primaryText)
          : (isMe ? context.theme.appColors.primaryText : context.theme.appColors.onPrimaryAccent),
      [type, isMe],
    );

    return MessageItemWrapper(
      messageEvent: eventMessage,
      isLastMessageFromAuthor: isLastMessageFromAuthor,
      contentPadding: EdgeInsets.symmetric(
        horizontal: 12.0.s,
        vertical: 12.0.s,
      ),
      isMe: isMe,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MessageAuthorNameWidget(author: author),
          Text(
            title,
            style: context.theme.appTextThemes.body2.copyWith(color: textColor),
          ),
          SizedBox(height: 10.0.s),
          Row(
            children: [
              Assets.svg.walletIce.icon(size: 36.0.s),
              SizedBox(width: 8.0.s),
              _AmountDisplay(
                amount: amount,
                equivalentUsd: equivalentUsd,
                chain: chain,
                isMe: isMe,
              ),
            ],
          ),
          SizedBox(height: 8.0.s),
          Button.compact(
            type: buttonType,
            backgroundColor: buttonBackgroundColor,
            tintColor: buttonType == ButtonType.primary ? buttonBackgroundColor : null,
            minimumSize: Size(150.0.s, 32.0.s),
            label: Text(
              buttonLabel,
              style: context.theme.appTextThemes.caption2.copyWith(
                color: buttonTextColor,
              ),
            ),
            onPressed: () {},
          ),
          const Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              //TODO: add metadata
              //MessageReactions(reactions: reactions),
              Spacer(),
              //TODO: add metadata
              // MessageMetaData(isMe: isMe, createdAt: createdAt),
            ],
          ),
        ],
      ),
    );
  }
}
