// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/features/wallets/data/models/network_data.c.dart';
import 'package:ion/app/features/wallets/data/models/transaction_data.c.dart';
import 'package:ion/app/features/wallets/data/models/transaction_type.dart';

part 'coin_transaction_data.c.freezed.dart';

@freezed
class CoinTransactionData with _$CoinTransactionData {
  const factory CoinTransactionData({
    required NetworkData network,
    required TransactionType transactionType,
    required double coinAmount,
    required double usdAmount,
    required int timestamp,
    required TransactionData origin,
  }) = _CoinTransactionData;
}
