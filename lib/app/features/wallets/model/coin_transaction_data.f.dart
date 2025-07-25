// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/features/wallets/model/network_data.f.dart';
import 'package:ion/app/features/wallets/model/transaction_data.f.dart';
import 'package:ion/app/features/wallets/model/transaction_type.dart';

part 'coin_transaction_data.f.freezed.dart';

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
