// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/features/wallets/model/coin_in_wallet_data.c.dart';
import 'package:ion/app/features/wallets/model/coins_group.c.dart';
import 'package:ion/app/features/wallets/model/nft_data.c.dart';
import 'package:ion_identity_client/ion_identity.dart';

part 'crypto_asset_data.c.freezed.dart';

@freezed
sealed class CryptoAssetData with _$CryptoAssetData {
  const factory CryptoAssetData.coin({
    required CoinsGroup coinsGroup,
    // Cache the selected option to avoid searching it each time
    CoinInWalletData? selectedOption,
    WalletAsset? associatedAssetWithSelectedOption,
    @Default(0.0) double amount,
    @Default(0.0) double priceUSD,
  }) = CoinAssetData;

  const factory CryptoAssetData.nft({
    required NftData nft,
  }) = NftAssetData;

  const factory CryptoAssetData.notInitialized() = _NotInitializedAssetData;

  const CryptoAssetData._();
}
