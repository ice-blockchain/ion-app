// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/features/wallet/model/coin_in_wallet_data.c.dart';

part 'wallet_view_data.c.freezed.dart';

/// Representation of the wallet view. Can contain many wallets/coins.
@freezed
class WalletViewData with _$WalletViewData {
  const factory WalletViewData({
    required String id,
    required String name,
    required List<CoinInWalletData> coins,
    required Set<String> symbolGroups,
    required double usdBalance,
    required String createdAt,
    required String updatedAt,
  }) = _WalletViewData;

  const WalletViewData._();
}
