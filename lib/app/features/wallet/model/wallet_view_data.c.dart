// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/features/wallet/model/coin_data.c.dart';

part 'wallet_view_data.c.freezed.dart';

@freezed
/// Representation of the wallet view on the backend.
class WalletViewData with _$WalletViewData {
  const factory WalletViewData({
    required String id,
    required String name,
    required String icon, // ?
    required List<CoinData> coins,
    required double usdBalance,
    required String createdAt,
    required String updatedAt,
  }) = _WalletViewData;

  const WalletViewData._();
}
