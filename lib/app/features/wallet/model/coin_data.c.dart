// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';

part 'coin_data.c.freezed.dart';

/// Domain data model for using inside the app. Contains information about coin.
@freezed
class CoinData with _$CoinData {
  const factory CoinData({
    required String id,
    required String contractAddress,
    required int decimals,
    required String iconUrl,
    required String name,
    required String network,
    required double priceUSD,
    required String abbreviation,
    required String symbolGroup,
    required Duration syncFrequency,
  }) = _CoinData;

  const CoinData._();
}
