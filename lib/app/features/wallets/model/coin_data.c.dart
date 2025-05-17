// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/features/wallets/data/database/wallets_database.c.dart' as db;
import 'package:ion/app/features/wallets/model/network_data.c.dart';
import 'package:ion_identity_client/ion_identity.dart' as ion;

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
    required NetworkData network,
    required double priceUSD,
    required String abbreviation,
    required String symbolGroup,
    required Duration syncFrequency,
    @Default(false) bool native,
    @Default(false) bool prioritized,
  }) = _CoinData;

  factory CoinData.fromDB(db.Coin coin, NetworkData network) {
    return CoinData(
      id: coin.id,
      contractAddress: coin.contractAddress,
      decimals: coin.decimals,
      iconUrl: coin.iconURL,
      name: coin.name,
      network: network,
      priceUSD: coin.priceUSD,
      abbreviation: coin.symbol.toUpperCase(),
      symbolGroup: coin.symbolGroup,
      syncFrequency: coin.syncFrequency,
      native: coin.native ?? false,
      prioritized: coin.prioritized ?? false,
    );
  }

  factory CoinData.fromDTO(ion.Coin coin, NetworkData network) {
    return CoinData(
      id: coin.id,
      contractAddress: coin.contractAddress,
      decimals: coin.decimals,
      iconUrl: coin.iconURL,
      name: coin.name,
      network: network,
      priceUSD: coin.priceUSD,
      abbreviation: coin.symbol.toUpperCase(),
      symbolGroup: coin.symbolGroup,
      syncFrequency: coin.syncFrequency,
      native: coin.native ?? false,
      prioritized: coin.prioritized ?? false,
    );
  }

  const CoinData._();
}
