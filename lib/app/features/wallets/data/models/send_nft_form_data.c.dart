// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/features/wallets/data/models/network_fee_option.c.dart';
import 'package:ion/app/features/wallets/data/models/nft_data.c.dart';
import 'package:ion/app/features/wallets/data/models/wallet_view_data.c.dart';
import 'package:ion_identity_client/ion_identity.dart';

part 'send_nft_form_data.c.freezed.dart';

@freezed
class SendNftFormData with _$SendNftFormData {
  const factory SendNftFormData({
    required int arrivalDateTime,
    required String receiverAddress,
    required NftData? nft,
    WalletViewData? walletView,
    Wallet? senderWallet,
    String? contactPubkey,
    WalletAsset? networkNativeToken,
    NetworkFeeOption? selectedNetworkFeeOption,
    @Default(true) bool canCoverNetworkFee,
    @Default([]) List<NetworkFeeOption> networkFeeOptions,
  }) = _SendNftFormData;
}
