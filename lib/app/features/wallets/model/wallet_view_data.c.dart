// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/features/wallets/model/coin_in_wallet_data.c.dart';
import 'package:ion/app/features/wallets/model/coins_group.c.dart';
import 'package:ion/app/features/wallets/model/nft_data.c.dart';

part 'wallet_view_data.c.freezed.dart';

/// Representation of the wallet view. Can contain many wallets/coins.
@freezed
class WalletViewData with _$WalletViewData {
  const factory WalletViewData({
    required String id,
    required String name,
    required List<CoinsGroup> coinGroups,
    required Set<String> symbolGroups,
    required List<NftData> nfts,
    required double usdBalance,
    required int createdAt,
    required int updatedAt,
    required bool isMainWalletView,
  }) = _WalletViewData;

  const WalletViewData._();

  List<CoinInWalletData> get coins => coinGroups.expand((e) => e.coins).toList();
}
