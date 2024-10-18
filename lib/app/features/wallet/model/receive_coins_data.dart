// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/features/wallet/model/coin_data.dart';
import 'package:ion/app/features/wallet/model/network_type.dart';

part 'receive_coins_data.freezed.dart';

@freezed
class ReceiveCoinsData with _$ReceiveCoinsData {
  const factory ReceiveCoinsData({
    required CoinData selectedCoin,
    required NetworkType selectedNetwork,
    required String address,
  }) = _ReceiveCoinsData;
}
