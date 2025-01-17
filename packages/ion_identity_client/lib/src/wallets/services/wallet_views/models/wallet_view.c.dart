// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion_identity_client/src/coins/models/coin.c.dart';
import 'package:ion_identity_client/src/wallets/services/wallet_views/models/wallet_view_aggregation_item.c.dart';
import 'package:ion_identity_client/src/wallets/services/wallet_views/models/coin_in_wallet.c.dart';

part 'wallet_view.c.freezed.dart';
part 'wallet_view.c.g.dart';

@freezed
class WalletView with _$WalletView {
  const factory WalletView({
    required String id,
    required String name,
    @CoinInWalletListConverter()
    required List<CoinInWallet> coins,
    @JsonKey(defaultValue: {})
    required Map<String, WalletViewAggregationItem> aggregation,
    required List<String> symbolGroups,
    required String createdAt,
    required String updatedAt,
    required String userId,
  }) = _WalletView;

  factory WalletView.fromJson(Map<String, dynamic> json) =>
      _$WalletViewFromJson(json);
}

class CoinInWalletListConverter implements JsonConverter<List<CoinInWallet>, List<dynamic>> {
  const CoinInWalletListConverter();

  @override
  List<CoinInWallet> fromJson(List<dynamic> json) {
    return json.map((e) {
      final json = e as Map<String, dynamic>;
      return CoinInWallet(
        walletId: json['wallet_id'] as String,
        coin: Coin.fromJson(json),
      );
    }).toList();
  }

  @override
  List<dynamic> toJson(List<CoinInWallet> object) {
    return object.map((coinWithWallet) {
      return {
        'wallet_id': coinWithWallet.walletId,
        ...coinWithWallet.toJson(),
      };
    }).toList();
  }
}
