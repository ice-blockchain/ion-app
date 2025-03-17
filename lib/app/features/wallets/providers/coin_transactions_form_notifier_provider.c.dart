import 'package:ion/app/features/wallets/model/coin_transaction_data.c.dart';
import 'package:ion/app/features/wallets/model/coin_transactions_form.c.dart';
import 'package:ion/app/features/wallets/model/network_data.c.dart';
import 'package:ion/app/features/wallets/providers/coin_transactions_provider.c.dart';
import 'package:ion/app/features/wallets/providers/synced_coins_by_symbol_group_provider.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'coin_transactions_form_notifier_provider.c.g.dart';

@riverpod
class CoinTransactionsFormNotifier extends _$CoinTransactionsFormNotifier {
  List<CoinTransactionData> _allTransactions = [];

  @override
  CoinTransactionsForm? build({
    required String symbolGroup,
  }) {
    final transactions =
        ref.watch(coinTransactionsNotifierProvider(symbolGroup: symbolGroup)).valueOrNull;
    final networks = ref.watch(
      syncedCoinsBySymbolGroupProvider(symbolGroup).select(
        (value) => value.maybeWhen(
          data: (list) => list.map((e) => e.coin.network).toList(),
          orElse: () => const <NetworkData>[],
        ),
      ),
    );
    final selectedNetwork = networks.firstOrNull;

    if (selectedNetwork == null || transactions == null) {
      return null;
    }

    _allTransactions = transactions;
    return CoinTransactionsForm(
      networks: networks,
      selectedNetwork: selectedNetwork,
      transactions: _allTransactions.filteredByNetwork(selectedNetwork),
    );
  }

  set network(NetworkData network) {
    if (state != null && state!.networks.contains(network)) {
      state = state!.copyWith(
        selectedNetwork: network,
        transactions: _allTransactions.filteredByNetwork(network),
      );
    }
  }
}

extension on List<CoinTransactionData> {
  List<CoinTransactionData> filteredByNetwork(NetworkData network) =>
      where((e) => e.network == network).toList();
}
