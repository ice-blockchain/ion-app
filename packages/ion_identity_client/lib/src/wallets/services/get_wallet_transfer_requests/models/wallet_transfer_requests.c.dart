// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion_identity_client/src/wallets/services/get_wallet_transfer_requests/models/wallet_transfer_request.c.dart';

part 'wallet_transfer_requests.c.freezed.dart';
part 'wallet_transfer_requests.c.g.dart';

@freezed
class WalletTransferRequests with _$WalletTransferRequests {
  const factory WalletTransferRequests({
    required String walletId,
    required List<WalletTransferRequest> items,
    String? nextPageToken,
  }) = _WalletTransferRequests;

  factory WalletTransferRequests.fromJson(Map<String, dynamic> json) =>
      _$WalletTransferRequestsFromJson(json);
}
