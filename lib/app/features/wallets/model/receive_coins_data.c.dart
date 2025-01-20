// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/features/wallets/model/coin_in_wallet_data.c.dart';
import 'package:ion/app/features/wallets/model/network_type.dart';

part 'receive_coins_data.c.freezed.dart';

@freezed
class ReceiveCoinsData with _$ReceiveCoinsData {
  const factory ReceiveCoinsData({
    required CoinInWalletData? selectedCoin,
    required NetworkType? selectedNetwork,
    required String? address,
  }) = _ReceiveCoinsData;
}
