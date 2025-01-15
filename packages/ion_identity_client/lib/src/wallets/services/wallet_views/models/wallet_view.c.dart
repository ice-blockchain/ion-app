// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion_identity_client/src/coins/models/coin.c.dart';
import 'package:ion_identity_client/src/wallets/services/wallet_views/models/wallet_view_aggregation_item.c.dart';

part 'wallet_view.c.freezed.dart';
part 'wallet_view.c.g.dart';

@freezed
class WalletView with _$WalletView {
  const factory WalletView({
    required String name,
    required List<Coin> coins,
    required Map<String, WalletViewAggregationItem> aggregation,
    required List<String> symbolGroups,
    required String createdAt,
    required String updatedAt,
    required String userId,
  }) = _WalletView;

  factory WalletView.fromJson(Map<String, dynamic> json) =>
      _$WalletViewFromJson(json);
}

// class _AggregationConverter extends JsonConverter<
//     Map<String, WalletViewAggregationItem>, Map<String, dynamic>> {
//   const _AggregationConverter();
//
//   @override
//   Map<String, WalletViewAggregationItem> fromJson(Map<String, dynamic> json) {
//     final result = json.map(
//       (key, value) {
//         return MapEntry(
//           key,
//           WalletViewAggregationItem.fromJson(value as Map<String, dynamic>),
//         );
//       },
//     );
//     return result;
//   }
//
//   @override
//   Map<String, dynamic> toJson(Map<String, WalletViewAggregationItem> object) {
//     return object.map((key, value) => MapEntry(key, value.toJson()));
//   }
// }

// {
// "name": "Ethereum",
// "coins": [
// {
// "id": "5dd50029-9d13-1ce6-017a-f481625db63c",
// "name": "Ethereum",
// "symbol": "eth",
// "symbolGroup": "ethereum",
// "network": "eth",
// "contractAddress": "",
// "iconURL": "https://coin-images.coingecko.com/coins/images/279/large/ethereum.png?1696501628",
// "priceUSD": 3917.15,
// "decimals": 18,
// "version": 0,
// "syncFrequency": 0,
// "walletId": "wa-7q1kh-804f4-8ssbeb9go74k4hid",
// "coinId": "5dd50029-9d13-1ce6-017a-f481625db63c"
// }
// ],
// "aggregation": {
// "eth": {
// "totalBalance": 0,
// "wallets": []
// }
// },
// "symbolGroups": [
// "ethereum"
// ],
// "createdAt": "2025-01-14T12:26:51.711614Z",
// "updatedAt": "2025-01-14T12:26:51.711614Z",
// "userId": "us-1m342-1r4tr-8bmpapqvo4v4eguf"
// }
