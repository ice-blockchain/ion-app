// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/features/wallets/data/models/coin_transaction_data.c.dart';

part 'coin_transaction_history_state.c.freezed.dart';

@freezed
class CoinTransactionHistoryState with _$CoinTransactionHistoryState {
  const factory CoinTransactionHistoryState({
    required List<CoinTransactionData> transactions,
    required bool isLoading,
    required bool hasMore,
  }) = _CoinTransactionHistoryState;

  const CoinTransactionHistoryState._();
}
