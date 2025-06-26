// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';

part 'wallet_view_coin_data.f.freezed.dart';
part 'wallet_view_coin_data.f.g.dart';

@freezed
class WalletViewCoinData with _$WalletViewCoinData {
  const factory WalletViewCoinData({
    required String coinId,
    String? walletId,
  }) = _WalletViewCoinData;

  factory WalletViewCoinData.fromJson(Map<String, dynamic> json) =>
      _$WalletViewCoinDataFromJson(json);
}
