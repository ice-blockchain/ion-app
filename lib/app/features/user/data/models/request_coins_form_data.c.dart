// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/features/wallets/model/crypto_asset_to_send_data.c.dart';
import 'package:ion/app/features/wallets/model/network_data.c.dart';
import 'package:ion_identity_client/ion_identity.dart';

part 'request_coins_form_data.c.freezed.dart';

@freezed
class RequestCoinsFormData with _$RequestCoinsFormData {
  const factory RequestCoinsFormData({
    CoinAssetToSendData? assetData,
    NetworkData? network,
    Wallet? toWallet,
    String? contactPubkey,
    WalletAsset? networkNativeToken,
  }) = _RequestCoinsFormData;
}
