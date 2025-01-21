// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion_identity_client/src/wallets/services/wallet_views/models/wallet_view_item.c.dart';

part 'create_update_wallet_view_request.c.freezed.dart';
part 'create_update_wallet_view_request.c.g.dart';

@freezed
class CreateUpdateWalletViewRequest with _$CreateUpdateWalletViewRequest {
  const factory CreateUpdateWalletViewRequest({
    required List<WalletViewItem> items,
    required List<String> symbolGroups,
    required String name,
  }) = _CreateWalletViewRequest;

  factory CreateUpdateWalletViewRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateUpdateWalletViewRequestFromJson(json);
}
