// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ice/app/features/wallet/model/coin_data.dart';

part 'manage_coin_data.freezed.dart';

@Freezed(copyWith: true)
class ManageCoinData with _$ManageCoinData {
  const factory ManageCoinData({
    required CoinData coinData,
    required bool isSelected,
  }) = _ManageCoinData;
}
