// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/components/list_item/list_item.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/wallets/model/coin_data.c.dart';
import 'package:ion/app/features/wallets/model/coin_transaction_data.c.dart';
import 'package:ion/app/features/wallets/model/transaction_type.dart';
import 'package:ion/app/features/wallets/views/components/network_icon_widget.dart';
import 'package:ion/app/features/wallets/views/pages/coins_flow/coin_details/components/transaction_list_item/transaction_list_item_leading_icon.dart';
import 'package:ion/app/features/wallets/views/utils/crypto_formatter.dart';
import 'package:ion/app/utils/date.dart';
import 'package:ion/app/utils/num.dart';

class TransactionListItem extends StatelessWidget {
  const TransactionListItem({
    required this.transactionData,
    required this.coinData,
    super.key,
  });

  final CoinTransactionData transactionData;
  final CoinData coinData;

  Color _getTextColor(BuildContext context) {
    return switch (transactionData.transactionType) {
      TransactionType.receive => context.theme.appColors.success,
      TransactionType.send => context.theme.appColors.primaryText,
    };
  }

  @override
  Widget build(BuildContext context) {
    return ListItem(
      title: Text(transactionData.transactionType.getDisplayName(context)),
      subtitle: Row(
        children: [
          NetworkIconWidget(
            size: 16.0.s,
            imageUrl: transactionData.network.image,
          ),
          SizedBox(
            width: 4.0.s,
          ),
          Text(
            toTimeDisplayValue(transactionData.timestamp),
          ),
        ],
      ),
      backgroundColor: context.theme.appColors.tertararyBackground,
      leading: TransactionListItemLeadingIcon(
        transactionType: transactionData.transactionType,
      ),
      trailing: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            '${transactionData.transactionType.sign}'
            '${formatCrypto(transactionData.coinAmount, '')} '
            '${coinData.abbreviation}',
            style: context.theme.appTextThemes.body.copyWith(
              color: _getTextColor(context),
            ),
          ),
          Text(
            '~ ${formatToCurrency(transactionData.usdAmount)}',
            style: context.theme.appTextThemes.caption3.copyWith(
              color: context.theme.appColors.secondaryText,
            ),
          ),
        ],
      ),
    );
  }
}
