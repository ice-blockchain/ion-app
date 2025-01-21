// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/features/wallets/model/coin_data.c.dart';

part 'manage_coin_data.c.freezed.dart';

@freezed
class ManageCoinData with _$ManageCoinData {
  const factory ManageCoinData({
    required CoinData coin,
    required bool isSelected,
  }) = _ManageCoinData;
}
