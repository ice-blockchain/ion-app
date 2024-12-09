// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/features/wallet/model/network_type.dart';
import 'package:ion/app/features/wallet/model/transaction_type.dart';

part 'coin_transaction_data.c.freezed.dart';

@freezed
class CoinTransactionData with _$CoinTransactionData {
  const factory CoinTransactionData({
    required NetworkType networkType,
    required TransactionType transactionType,
    required double coinAmount,
    required double usdAmount,
    required int timestamp,
  }) = _CoinTransactionData;
}
