// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion_identity_client/src/wallets/services/wallet_views/models/wallet_view_coin_data.dart';
import 'package:ion_identity_client/src/wallets/services/wallet_views/models/wallet_view_item.dart';

part 'wallet_view.freezed.dart';
part 'wallet_view.g.dart';

@freezed
class WalletView with _$WalletView {
  const factory WalletView({
    required Map<String, WalletViewCoinData> coins,
    required String createdAt,
    required List<WalletViewItem> items,
    required String name,
    required String updatedAt,
    required String userId,
  }) = _WalletView;

  factory WalletView.fromJson(Map<String, dynamic> json) => _$WalletViewFromJson(json);
}
