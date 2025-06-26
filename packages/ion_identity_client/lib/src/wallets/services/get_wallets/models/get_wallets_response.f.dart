// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion_identity_client/src/wallets/models/wallet.f.dart';

part 'get_wallets_response.f.freezed.dart';
part 'get_wallets_response.f.g.dart';

@freezed
class GetWalletsResponse with _$GetWalletsResponse {
  factory GetWalletsResponse({
    required List<Wallet> items,
  }) = _GetWalletsResponse;

  factory GetWalletsResponse.fromJson(Map<String, dynamic> json) =>
      _$GetWalletsResponseFromJson(json);
}
