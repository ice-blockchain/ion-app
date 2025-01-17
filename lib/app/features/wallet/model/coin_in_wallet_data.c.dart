// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/features/wallet/model/coin_data.c.dart';

part 'coin_in_wallet_data.c.freezed.dart';

@freezed
class CoinInWalletData with _$CoinInWalletData {
  const factory CoinInWalletData({
    required CoinData coin,
    required double amount,
    required double balanceUSD,
    required String walletId, // real wallet, not wallet view
  }) = _CoinInWalletData;

  const CoinInWalletData._();
}
