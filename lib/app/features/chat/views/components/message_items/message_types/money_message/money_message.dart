// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/extensions/object.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/chat/model/message_list_item.c.dart';
import 'package:ion/app/features/chat/model/money_message_type.dart';
import 'package:ion/app/features/chat/recent_chats/providers/money_message_provider.c.dart';
import 'package:ion/app/features/chat/views/components/message_items/components.dart';
import 'package:ion/app/features/chat/views/components/message_items/message_types/money_message/components/money_message_button.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';
import 'package:ion/app/features/wallets/model/coin_data.c.dart';
import 'package:ion/app/features/wallets/model/entities/funds_request_entity.c.dart';
import 'package:ion/app/features/wallets/model/network_data.c.dart';
import 'package:ion/app/features/wallets/providers/coins_provider.c.dart';
import 'package:ion/app/features/wallets/providers/networks_provider.c.dart';
import 'package:ion/app/features/wallets/views/components/network_icon_widget.dart';
import 'package:ion/app/utils/date.dart';
import 'package:ion/app/utils/num.dart';

part 'components/amount_display.dart';

class MoneyMessage extends HookConsumerWidget {
  const MoneyMessage({
    required this.eventMessage,
    super.key,
  });

  final EventMessage eventMessage;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventReference =
        EventReference.fromEncoded(eventMessage.content) as ImmutableEventReference;

    final isMe = ref.watch(isCurrentUserSelectorProvider(eventReference.pubkey));

    final fundsRequestAsync = ref.watch(fundsRequestForMessageProvider(eventReference.eventId));
    final fundsRequest = fundsRequestAsync.value;

    final networkId = fundsRequest?.data.networkId;
    final network = ref.watch(networkByIdProvider(networkId.emptyOrValue)).value;

    final assetId = fundsRequest?.data.content.assetId?.emptyOrValue;
    final coin = ref.watch(coinByIdProvider(assetId.emptyOrValue)).value;

    // TODO: currently hardcoded, will be dynamic when we implement paid requests.
    const type = MoneyMessageType.requested;

    final amount = fundsRequest?.data.content.amount?.let(double.parse) ?? 0.0;
    final equivalentUsd = fundsRequest?.data.content.amountUsd?.let(double.parse) ?? 0.0;

    return _MoneyMessageContent(
      isMe: isMe,
      type: type,
      amount: amount,
      equivalentUsd: equivalentUsd,
      network: network,
      coin: coin,
      eventMessage: eventMessage,
      eventId: eventReference.eventId,
      request: fundsRequest,
    );
  }
}

class _MoneyMessageContent extends HookConsumerWidget {
  const _MoneyMessageContent({
    required this.isMe,
    required this.type,
    required this.amount,
    required this.equivalentUsd,
    required this.network,
    required this.coin,
    required this.eventMessage,
    required this.eventId,
    required this.request,
  });

  final bool isMe;
  final MoneyMessageType type;
  final double amount;
  final double equivalentUsd;
  final NetworkData? network;
  final CoinData? coin;
  final EventMessage eventMessage;
  final String eventId;
  final FundsRequestEntity? request;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textColor = switch (isMe) {
      true => context.theme.appColors.onPrimaryAccent,
      false => context.theme.appColors.primaryText,
    };

    final title = switch (type) {
      MoneyMessageType.received => context.i18n.chat_money_received_title,
      MoneyMessageType.requested => context.i18n.chat_money_request_title,
    };

    final timeTextColor = switch (isMe) {
      true => context.theme.appColors.strokeElements,
      false => context.theme.appColors.quaternaryText,
    };

    final isPaid = type == MoneyMessageType.received;

    return MessageItemWrapper(
      messageItem: ChatMessageInfoItem.money(
        eventMessage: eventMessage,
        contentDescription: title,
      ),
      contentPadding: EdgeInsets.symmetric(
        horizontal: 12.0.s,
        vertical: 12.0.s,
      ),
      isMe: isMe,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: context.theme.appTextThemes.body2.copyWith(color: textColor),
          ),
          SizedBox(height: 10.0.s),
          Row(
            children: [
              NetworkIconWidget(
                imageUrl: network?.image ?? '',
                size: 36.0.s,
              ),
              SizedBox(width: 8.0.s),
              _AmountDisplay(
                amount: amount,
                equivalentUsd: equivalentUsd,
                chain: network?.displayName ?? '',
                coin: coin?.abbreviation,
                isMe: isMe,
              ),
            ],
          ),
          SizedBox(height: 8.0.s),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              MoneyMessageButton(
                isMe: isMe,
                messageType: type,
                eventId: eventId,
                isPaid: isPaid,
                request: request,
              ),
              Text(
                toTimeDisplayValue(eventMessage.createdAt.millisecondsSinceEpoch),
                style: context.theme.appTextThemes.caption4.copyWith(color: timeTextColor),
              ),
              // TODO: implement reactions
            ],
          ),
        ],
      ),
    );
  }
}
