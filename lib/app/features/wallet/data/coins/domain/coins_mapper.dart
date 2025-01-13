// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/features/wallet/data/coins/database/coins_database.c.dart';
import 'package:ion_identity_client/ion_identity.dart' as ion_identity;

class CoinsMapper {
  static List<Coin> fromIONIdentityCoins(List<ion_identity.Coin> coins) {
    return coins
        .map(
          (coin) => Coin(
            id: coin.id,
            name: coin.name,
            symbol: coin.symbol,
            iconURL: coin.iconURL,
            network: coin.network,
            priceUSD: coin.priceUSD,
            decimals: coin.decimals,
            syncFrequency: coin.syncFrequency,
            contractAddress: coin.contractAddress,
            symbolGroup: coin.symbolGroup,
          ),
        )
        .toList();
  }

  static List<ion_identity.Coin> toIONIdentityCoins(List<Coin> coins) {
    return coins
        .map(
          (coin) => ion_identity.Coin(
            id: coin.id,
            name: coin.name,
            symbol: coin.symbol,
            iconURL: coin.iconURL,
            network: coin.network,
            priceUSD: coin.priceUSD,
            decimals: coin.decimals,
            syncFrequency: coin.syncFrequency,
            contractAddress: coin.contractAddress,
            symbolGroup: coin.symbolGroup,
          ),
        )
        .toList();
  }
}
