// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion_identity_client/src/wallets/models/requester.dart';
import 'package:ion_identity_client/src/wallets/services/get_wallet_transfer_requests/models/transfer_request_body.dart';

part 'wallet_transfer_request.freezed.dart';
part 'wallet_transfer_request.g.dart';

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
  }) = _WalletTransferRequest;

  factory WalletTransferRequest.fromJson(Map<String, dynamic> json) =>
      _$WalletTransferRequestFromJson(json);
}
