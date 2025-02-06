// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/features/wallets/model/coins_group.c.dart';
import 'package:ion/app/features/wallets/model/nft_data.c.dart';

part 'crypto_asset_data.c.freezed.dart';

@freezed
sealed class CryptoAssetData with _$CryptoAssetData {
  const factory CryptoAssetData.coin({
    required CoinsGroup coin,
    @Default(0.0) double amount,
    @Default(0.0) double maxAmount,
  }) = CoinAssetData;

  const factory CryptoAssetData.nft({
    required NftData nft,
  }) = NftAssetData;

  const CryptoAssetData._();

  // double? get price => switch (this) {
  //       CoinAssetData(:final coin) => coin.totalBalanceUSD,
  //       NftAssetData(:final nft) => nft.price,
  //     };
  //
  // String get networkName => switch (this) {
  //       CoinAssetData(:final coin) =>
  //         'Not implemented', // TODO: Implement when needed
  //       NftAssetData(:final nft) => nft.network.displayName,
  //     };
}
