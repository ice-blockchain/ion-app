// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/features/wallets/model/coins_group.f.dart';
import 'package:ion/app/features/wallets/model/network_data.f.dart';

part 'receive_coins_data.f.freezed.dart';

@freezed
class ReceiveCoinsData with _$ReceiveCoinsData {
  const factory ReceiveCoinsData({
    required CoinsGroup? selectedCoin,
    required NetworkData? selectedNetwork,
    required String? address,
  }) = _ReceiveCoinsData;
}
