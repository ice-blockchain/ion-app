// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/features/wallets/model/coin_in_wallet_data.c.dart';
import 'package:ion/app/features/wallets/model/coins_group.c.dart';
import 'package:ion/app/features/wallets/model/nft_data.c.dart';
import 'package:ion_identity_client/ion_identity.dart';

part 'crypto_asset_to_send_data.c.freezed.dart';

@freezed
sealed class CryptoAssetToSendData with _$CryptoAssetToSendData {
  const factory CryptoAssetToSendData.coin({
    required CoinsGroup coinsGroup,
    @Default(0.0) double amount,
    @Default(0.0) double amountUSD,
    @Default('0') String rawAmount,
    // Cache the selected option to avoid searching it each time
    CoinInWalletData? selectedOption,
    WalletAsset? associatedAssetWithSelectedOption,
  }) = CoinAssetToSendData;

  const factory CryptoAssetToSendData.nft({
    required NftData nft,
  }) = NftAssetToSendData;

  const factory CryptoAssetToSendData.notInitialized() = _NotInitializedAssetData;

  const CryptoAssetToSendData._();
}
