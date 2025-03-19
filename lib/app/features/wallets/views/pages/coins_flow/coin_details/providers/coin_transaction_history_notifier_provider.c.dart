// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/features/wallets/model/coin_transaction_data.c.dart';
import 'package:ion/app/features/wallets/model/network_data.c.dart';
import 'package:ion/app/features/wallets/providers/coin_transactions_provider.c.dart';
import 'package:ion/app/features/wallets/views/pages/coins_flow/coin_details/providers/network_selector_notifier.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'coin_transaction_history_notifier_provider.c.g.dart';

typedef CoinTransactionHistoryState = ({
  List<CoinTransactionData>? transactions,
  bool hasMore,
  NetworkData network,
});

@riverpod
class CoinTransactionHistoryNotifier extends _$CoinTransactionHistoryNotifier {
  @override
  CoinTransactionHistoryState? build({required String symbolGroup}) {
    final selectedNetwork = ref.watch(
      networkSelectorNotifierProvider(symbolGroup: symbolGroup).select((state) => state?.selected),
    );

    if (selectedNetwork == null) return null;

    final transactionsValue = ref
        .watch(
          coinTransactionsNotifierProvider(symbolGroup: symbolGroup, network: selectedNetwork),
        )
        .valueOrNull;

    if (transactionsValue == null) return null;

    final (:transactions, :hasMore, :coin) = transactionsValue;

    return (transactions: transactions, network: selectedNetwork, hasMore: hasMore);
  }

  Future<void> loadMore() async {
    if (state?.hasMore ?? false) {
      return ref
          .read(
            coinTransactionsNotifierProvider(
              symbolGroup: symbolGroup,
              network: state!.network,
            ).notifier,
          )
          .loadMore();
    }
  }
}
