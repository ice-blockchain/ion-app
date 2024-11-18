// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion_identity_client/src/wallets/services/wallet_views/models/wallet_view_wallet.dart';

part 'wallet_view_coin_data.freezed.dart';
part 'wallet_view_coin_data.g.dart';

@freezed
class WalletViewCoinData with _$WalletViewCoinData {
  const factory WalletViewCoinData({
    required Map<String, dynamic> totalBalance,
    required List<WalletViewWallet> wallets,
  }) = _WalletViewCoinData;

  factory WalletViewCoinData.fromJson(Map<String, dynamic> json) =>
      _$WalletViewCoinDataFromJson(json);
}
