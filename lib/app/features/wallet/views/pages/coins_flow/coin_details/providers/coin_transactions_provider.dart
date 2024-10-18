// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/features/wallet/model/coin_transaction_data.dart';
import 'package:ion/app/features/wallet/model/network_type.dart';
import 'package:ion/app/features/wallet/views/pages/coins_flow/coin_details/providers/mock_data/transactions_mock_data.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'coin_transactions_provider.g.dart';

@riverpod
class CoinTransactionsNotifier extends _$CoinTransactionsNotifier {
  @override
  AsyncValue<List<CoinTransactionData>> build() {
    return AsyncData<List<CoinTransactionData>>(
      List<CoinTransactionData>.unmodifiable(<CoinTransactionData>[]),
    );
  }

  Future<void> fetch({
    required String walletId,
    required String coinId,
    required NetworkType networkType,
  }) async {
    state = const AsyncLoading<List<CoinTransactionData>>().copyWithPrevious(state);

    // to emulate loading state
    await Future<void>.delayed(const Duration(seconds: 1));

    state = AsyncData<List<CoinTransactionData>>(
      List<CoinTransactionData>.unmodifiable(
        mockedCoinTransactionData.where(
          (CoinTransactionData data) =>
              networkType == NetworkType.all || data.networkType == networkType,
        ),
      ),
    );
  }
}
