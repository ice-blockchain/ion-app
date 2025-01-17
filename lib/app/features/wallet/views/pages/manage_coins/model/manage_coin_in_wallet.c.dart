// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/features/wallet/model/coin_in_wallet_data.c.dart';

part 'manage_coin_in_wallet.c.freezed.dart';

@freezed
class ManageCoinInWallet with _$ManageCoinInWallet {
  const factory ManageCoinInWallet({
    required CoinInWalletData coinInWallet,
    required bool isSelected,
  }) = _ManageCoinInWallet;
}
