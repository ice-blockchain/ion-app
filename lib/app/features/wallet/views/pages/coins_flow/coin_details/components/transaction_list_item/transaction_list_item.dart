// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ice/app/components/list_item/list_item.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/wallet/model/coin_data.dart';
import 'package:ice/app/features/wallet/model/coin_transaction_data.dart';
import 'package:ice/app/features/wallet/model/transaction_type.dart';
import 'package:ice/app/features/wallet/views/pages/coins_flow/coin_details/components/transaction_list_item/transaction_list_item_leading_icon.dart';
import 'package:ice/app/utils/date.dart';
import 'package:ice/app/utils/num.dart';

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
          transactionData.networkType.iconAsset.icon(size: 16.0.s),
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
            '${formatToCurrency(transactionData.coinAmount, '')} '
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
