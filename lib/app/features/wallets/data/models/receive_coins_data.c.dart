// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/features/wallets/data/models/coins_group.c.dart';
import 'package:ion/app/features/wallets/data/models/network_data.c.dart';

part 'receive_coins_data.c.freezed.dart';

@freezed
class ReceiveCoinsData with _$ReceiveCoinsData {
  const factory ReceiveCoinsData({
    required CoinsGroup? selectedCoin,
    required NetworkData? selectedNetwork,
    required String? address,
  }) = _ReceiveCoinsData;
}
