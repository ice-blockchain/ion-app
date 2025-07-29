// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/features/wallets/model/coin_data.f.dart';
import 'package:ion/app/features/wallets/model/transaction_data.f.dart';

part 'wallet_view_update.f.freezed.dart';

@freezed
class WalletViewUpdate with _$WalletViewUpdate {
  const factory WalletViewUpdate({
    required List<CoinData> updatedCoins,
    required Map<CoinData, List<TransactionData>> coinTransactions,
    required List<TransactionData> nftTransactions,
  }) = _WalletViewUpdate;
}
