// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion_identity_client/src/wallets/services/wallet_views/models/wallet_view_item.c.dart';

part 'create_wallet_view_request.c.freezed.dart';
part 'create_wallet_view_request.c.g.dart';

@freezed
class CreateWalletViewRequest with _$CreateWalletViewRequest {
  const factory CreateWalletViewRequest({
    required List<WalletViewItem> items,
    required List<String> symbolGroups,
    required String name,
  }) = _CreateWalletViewRequest;

  factory CreateWalletViewRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateWalletViewRequestFromJson(json);
}
