// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/features/wallets/model/crypto_asset_data.c.dart';
import 'package:ion/app/features/wallets/model/network_data.c.dart';
import 'package:ion/app/features/wallets/model/network_fee_option.c.dart';
import 'package:ion/app/features/wallets/model/wallet_view_data.c.dart';
import 'package:ion_identity_client/ion_identity.dart';

part 'send_asset_form_data.c.freezed.dart';

@freezed
class SendAssetFormData with _$SendAssetFormData {
  const factory SendAssetFormData({
    required WalletViewData wallet,
    required DateTime arrivalDateTime,
    required String receiverAddress,
    required CryptoAssetData assetData,
    NetworkData? network,
    Wallet? senderWallet,
    String? contactPubkey,
    WalletAsset? networkNativeToken,
    NetworkFeeOption? selectedNetworkFeeOption,
    @Default(true) bool canCoverNetworkFee,
    @Default([]) List<NetworkFeeOption> networkFeeOptions,
    @Default(false) bool isContactPreselected,
  }) = _SendAssetFormData;
}
