// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ice/generated/assets.gen.dart';

part 'coin_data.freezed.dart';

@freezed
class CoinData with _$CoinData {
  const factory CoinData({
    required String abbreviation,
    required String name,
    required double amount,
    required double balance,
    required AssetGenImage iconUrl,
    required String asset,
    required String network,
  }) = _CoinData;
}
