import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/features/wallet/model/coin_transaction_data.dart';
import 'package:ice/app/features/wallet/views/pages/coins_flow/coin_details/providers/coin_transactions_provider.dart';
import 'package:ice/app/utils/date.dart';

Map<String, List<CoinTransactionData>> useTransactionsByDate(
  BuildContext context,
  WidgetRef ref,
) {
  final coinTransactions = ref.watch(
    coinTransactionsNotifierProvider.select((data) => data.valueOrNull ?? []),
  );

  return useMemoized(
    () {
      // Can be simplified like this:
      // final transactions = coinTransactions.sortedBy<num>(
      //   (transaction) => -transaction.timestamp,
      // );

      // return transactions.groupListsBy(
      //   (transaction) => toPastDateDisplayValue(transaction.timestamp, context),
      // );

      final transactions = List<CoinTransactionData>.from(coinTransactions)
        ..sort(
          (CoinTransactionData a, CoinTransactionData b) => b.timestamp.compareTo(a.timestamp),
        );
      final result = <String, List<CoinTransactionData>>{};
      for (final transaction in transactions) {
        final dateKey = toPastDateDisplayValue(transaction.timestamp, context);
        if (result[dateKey] == null) {
          result[dateKey] = <CoinTransactionData>[];
        }
        result[dateKey]!.add(transaction);
      }
      return result;
    },
    [coinTransactions, context],
  );
}
