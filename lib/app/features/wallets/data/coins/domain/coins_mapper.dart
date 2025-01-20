// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/features/wallets/data/coins/database/coins_database.c.dart';
import 'package:ion_identity_client/ion_identity.dart' as ion_identity;

class CoinsMapper {
  List<Coin> fromDtoToDb(List<ion_identity.Coin> coins) => [
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
