import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/features/wallet/model/coin_transaction_data.dart';
import 'package:ice/app/features/wallet/views/pages/coin_details/providers/selectors/coin_transactions_selectors.dart';
import 'package:ice/app/utils/date.dart';

Map<String, List<CoinTransactionData>> useTransactionsByDate(
  BuildContext context,
  WidgetRef ref,
) {
  final List<CoinTransactionData> coinTransactions =
      coinTransactionsSelector(ref);

  return useMemoized(
    () {
      final List<CoinTransactionData> transactions =
          List<CoinTransactionData>.from(coinTransactions);
      transactions.sort(
        (CoinTransactionData a, CoinTransactionData b) =>
            b.timestamp.compareTo(a.timestamp),
      );
      final Map<String, List<CoinTransactionData>> result =
          <String, List<CoinTransactionData>>{};
      for (final CoinTransactionData transaction in transactions) {
        final String dateKey =
            toPastDateDisplayValue(transaction.timestamp, context);
        if (result[dateKey] == null) {
          result[dateKey] = <CoinTransactionData>[];
        }
        result[dateKey]!.add(transaction);
      }
      return result;
    },
    <Object?>[coinTransactions, context],
  );
}
