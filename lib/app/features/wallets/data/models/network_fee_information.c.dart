// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/features/wallets/data/models/network_fee_option.c.dart';
import 'package:ion_identity_client/ion_identity.dart';

part 'network_fee_information.c.freezed.dart';

@freezed
class NetworkFeeInformation with _$NetworkFeeInformation {
  const factory NetworkFeeInformation({
    required List<NetworkFeeOption> networkFeeOptions,
    required WalletAsset networkNativeToken,
    required WalletAsset sendableAsset,
  }) = _NetworkFeeInformation;
}
