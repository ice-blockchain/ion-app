// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/features/wallet/model/coin_data.c.dart';
import 'package:ion/app/features/wallet/model/contact_data.c.dart';
import 'package:ion/app/features/wallet/model/network_type.dart';
import 'package:ion/app/features/wallet/model/nft_data.c.dart';
import 'package:ion/app/features/wallet/model/wallet_data.c.dart';

part 'crypto_asset_data.c.freezed.dart';

@freezed
class CryptoAssetData with _$CryptoAssetData {
  const factory CryptoAssetData({
    required WalletData wallet,
    required NetworkType selectedNetwork,
    required int arrivalTime,
    required DateTime arrivalDateTime,
    required String address,
    CoinData? selectedCoin,
    NftData? selectedNft,
    double? amount,
    ContactData? selectedContact,
  }) = _CryptoAssetData;
}
