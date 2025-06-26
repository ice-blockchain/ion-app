// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';

part 'wallet_view_wallet.f.freezed.dart';
part 'wallet_view_wallet.f.g.dart';

@freezed
class WalletViewWallet with _$WalletViewWallet {
  const factory WalletViewWallet({
    required Map<String, String> asset,
    required String network,
    required String walletId,
  }) = _WalletViewWallet;

  factory WalletViewWallet.fromJson(Map<String, dynamic> json) => _$WalletViewWalletFromJson(json);
}
