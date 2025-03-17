// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/features/wallets/model/entities/wallet_asset_entity.c.dart';
import 'package:ion/app/features/wallets/model/network_data.c.dart';
import 'package:ion/app/features/wallets/model/transaction_type.dart';

part 'coin_transaction_data.c.freezed.dart';

@freezed
class CoinTransactionData with _$CoinTransactionData {
  const factory CoinTransactionData({
    required NetworkData network,
    required TransactionType transactionType,
    required double coinAmount,
    required double usdAmount,
    required int timestamp,
    required WalletAssetEntity entity,
    required WalletAssetContent content,
  }) = _CoinTransactionData;
}
