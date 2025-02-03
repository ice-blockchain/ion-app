// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/features/wallets/model/coin_data.c.dart';

part 'coin_in_wallet_data.c.freezed.dart';

@freezed
class CoinInWalletData with _$CoinInWalletData {
  const factory CoinInWalletData({
    required CoinData coin,
    @Default(0) double amount,
    @Default(0) double balanceUSD,
    String? walletId, // real wallet, not wallet view. Can be null if wallet wasn't created.
    String? walletAddress,
  }) = _CoinInWalletData;

  const CoinInWalletData._();
}
