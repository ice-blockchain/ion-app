// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/features/wallets/model/crypto_asset_data.c.dart';
import 'package:ion/app/features/wallets/model/network.dart';
import 'package:ion/app/features/wallets/model/wallet_view_data.c.dart';

part 'send_asset_form_data.c.freezed.dart';

@freezed
class SendAssetFormData with _$SendAssetFormData {
  const factory SendAssetFormData({
    required WalletViewData wallet,
    required Network network,
    required int arrivalTime,
    required DateTime arrivalDateTime,
    required String address,
    String? contactPubkey,
    CryptoAssetData? assetData,
  }) = _SendAssetFormData;
}
