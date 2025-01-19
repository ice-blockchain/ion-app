// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/features/wallet/data/coins/database/coins_database.c.dart';

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

  factory CoinData.fromDB(Coin coin) {
    return CoinData(
      id: coin.id,
      contractAddress: coin.contractAddress,
      decimals: coin.decimals,
      iconUrl: coin.iconURL,
      name: coin.name,
      network: coin.network,
      priceUSD: coin.priceUSD,
      abbreviation: coin.symbol,
      symbolGroup: coin.symbolGroup,
      syncFrequency: coin.syncFrequency,
    );
  }

  const CoinData._();
}
