// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion_identity_client/src/wallets/services/wallet_views/models/wallet_view_coin_data.c.dart';

part 'short_wallet_view.c.freezed.dart';
part 'short_wallet_view.c.g.dart';

@freezed
class ShortWalletView with _$ShortWalletView {
  const factory ShortWalletView({
    required String name,
    required List<WalletViewCoinData> coins,
    required List<String> symbolGroups,
    required String createdAt,
    required String updatedAt,
    required String userId,
    required String id,
  }) = _ShortWalletView;

  factory ShortWalletView.fromJson(Map<String, dynamic> json) => _$ShortWalletViewFromJson(json);
}
