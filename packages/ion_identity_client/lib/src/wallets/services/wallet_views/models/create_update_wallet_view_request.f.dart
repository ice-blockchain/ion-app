// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion_identity_client/src/wallets/services/wallet_views/models/wallet_view_coin_data.f.dart';

part 'create_update_wallet_view_request.f.freezed.dart';
part 'create_update_wallet_view_request.f.g.dart';

@freezed
class CreateUpdateWalletViewRequest with _$CreateUpdateWalletViewRequest {
  const factory CreateUpdateWalletViewRequest({
    required List<WalletViewCoinData> items,
    required List<String> symbolGroups,
    required String name,
  }) = _CreateWalletViewRequest;

  factory CreateUpdateWalletViewRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateUpdateWalletViewRequestFromJson(json);
}
