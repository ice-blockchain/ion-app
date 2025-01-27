// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/features/wallets/model/coin_in_wallet_data.c.dart';
import 'package:ion/app/features/wallets/model/network_type.dart';
import 'package:ion/app/features/wallets/model/nft_data.c.dart';
import 'package:ion/app/features/wallets/model/wallet_view_data.c.dart';

part 'crypto_asset_data.c.freezed.dart';

@freezed
class CryptoAssetData with _$CryptoAssetData {
  const factory CryptoAssetData({
    required WalletViewData wallet,
    required NetworkType selectedNetwork,
    required int arrivalTime,
    required DateTime arrivalDateTime,
    required String address,
    CoinInWalletData? selectedCoin,
    NftData? selectedNft,
    String? selectedContactPubkey,
  }) = _CryptoAssetData;

  const CryptoAssetData._();

  double? get price {
    if (selectedCoin != null) return selectedCoin!.balanceUSD;
    if (selectedNft != null) return selectedNft!.price;
    return null;
  }

  String get networkName {
    if (selectedCoin != null) return selectedCoin!.coin.network;
    if (selectedNft != null) return selectedNft!.network;
    return '';
  }
}
