// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion_identity_client/src/wallets/models/requester.f.dart';
import 'package:ion_identity_client/src/wallets/services/get_wallet_transfer_requests/models/transfer_request_body.f.dart';

part 'wallet_transfer_request.f.freezed.dart';
part 'wallet_transfer_request.f.g.dart';

@freezed
class WalletTransferRequest with _$WalletTransferRequest {
  const factory WalletTransferRequest({
    required String id,
    required String walletId,
    required String network,
    required Requester requester,
    required TransferRequestBody requestBody,
    required String status,
    required DateTime dateRequested,
    String? txHash,
    String? fee,
    DateTime? dateBroadcasted,
    DateTime? dateConfirmed,
    String? reason,
    Map<String, dynamic>? metadata,
  }) = _WalletTransferRequest;

  factory WalletTransferRequest.fromJson(Map<String, dynamic> json) =>
      _$WalletTransferRequestFromJson(json);
}
