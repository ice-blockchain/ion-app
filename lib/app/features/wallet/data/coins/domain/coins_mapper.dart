// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/features/wallet/data/coins/database/coins_database.c.dart';
import 'package:ion/app/features/wallet/model/coin_data.c.dart';
import 'package:ion_identity_client/ion_identity.dart' as ion_identity;

class CoinsMapper {
  static List<Coin> fromDtoToDb(List<ion_identity.Coin> coins) {
    return [
      for (final coin in coins)
        Coin(
          id: coin.id,
          contractAddress: coin.contractAddress,
          decimals: coin.decimals,
          iconURL: coin.iconURL,
          name: coin.name,
          network: coin.network,
          priceUSD: coin.priceUSD,
          symbol: coin.symbol,
          symbolGroup: coin.symbolGroup,
          syncFrequency: coin.syncFrequency,
        ),
    ];
  }

  static List<CoinData> fromDbToDomain(List<Coin> coins) {
    return [
      for (final coin in coins)
        CoinData(
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
        ),
    ];
  }
}
