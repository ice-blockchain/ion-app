// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/features/wallets/data/models/crypto_asset_to_send_data.c.dart';
import 'package:ion/app/features/wallets/data/models/entities/funds_request_entity.c.dart';
import 'package:ion/app/features/wallets/data/models/network_data.c.dart';
import 'package:ion/app/features/wallets/data/models/network_fee_option.c.dart';
import 'package:ion/app/features/wallets/data/models/wallet_view_data.c.dart';
import 'package:ion_identity_client/ion_identity.dart';

part 'send_asset_form_data.c.freezed.dart';

@freezed
class SendAssetFormData with _$SendAssetFormData {
  const factory SendAssetFormData({
    required int arrivalDateTime,
    required String receiverAddress,
    required CryptoAssetToSendData assetData,
    WalletViewData? walletView,
    NetworkData? network,
    Wallet? senderWallet,
    String? contactPubkey,
    WalletAsset? networkNativeToken,
    NetworkFeeOption? selectedNetworkFeeOption,
    FundsRequestEntity? request,
    @Default(true) bool canCoverNetworkFee,
    @Default([]) List<NetworkFeeOption> networkFeeOptions,
    @Default(false) bool isContactPreselected,
    @Default(false) bool exceedsMaxAmount,
  }) = _SendAssetFormData;
}
