import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/features/wallet/model/coin_transaction_data.dart';
import 'package:ice/app/features/wallet/views/pages/coins_flow/coin_details/providers/coin_transactions_provider.dart';

List<CoinTransactionData> coinTransactionsSelector(WidgetRef ref) {
  return ref.watch(
    coinTransactionsNotifierProvider.select(
      (AsyncValue<List<CoinTransactionData>> data) => data.value ?? <CoinTransactionData>[],
    ),
  );
}

bool coinTransactionsIsLoadingSelector(WidgetRef ref) {
  return ref.watch(
    coinTransactionsNotifierProvider.select(
      (AsyncValue<List<CoinTransactionData>> data) => data.isLoading,
    ),
  );
}
