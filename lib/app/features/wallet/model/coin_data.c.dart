// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/generated/assets.gen.dart';

part 'coin_data.c.freezed.dart';

@freezed
class CoinData with _$CoinData {
  // final String id;
  // final String contractAddress;
  // final int decimals;
  // final String iconURL;
  // final String name;
  // final String network;
  // final double priceUSD;
  // final String symbol;
  // final String symbolGroup;
  // final Duration syncFrequency;

  const factory CoinData({
    required String id,
    required String contractAddress,
    required int decimals,
    required String iconUrl,
    required String name,
    required String network,
    required double priceUSD,
    required String symbol,
    required String symbolGroup,
    required String walletId, // real wallet, not wallet view
    required Duration syncFrequency,

    // required String abbreviation,
    // required String name,
    // required double amount,
    // required double balance,
    // required AssetGenImage iconUrl,
    // required String asset,
    // required String network,
  }) = _CoinData;

  const CoinData._();
}


// required List<Coin> coins,
// required Map<String, WalletViewAggregationItem> aggregation,
// required List<String> symbolGroups,