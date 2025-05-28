// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/features/wallets/model/transaction_status.c.dart';
import 'package:ion_identity_client/ion_identity.dart';

part 'transfer_result.c.freezed.dart';
part 'transfer_result.c.g.dart';

@freezed
class TransferResult with _$TransferResult {
  const factory TransferResult({
    required String id,
    required String? txHash,
    required String walletId,
    required TransactionStatus status,
    required Map<String, dynamic> requester,
    required Map<String, dynamic> requestBody,
    required Map<String, dynamic>? metadata,
    required int dateRequested,
    required int? dateConfirmed,
    required int? dateBroadcasted,
    required String network,
    required String? reason,
  }) = _TransferResult;

  factory TransferResult.fromJson(Map<String, dynamic> json) => _$TransferResultFromJson(json);

  factory TransferResult.fromDTO(WalletTransferRequest request) => TransferResult(
        id: request.id,
        txHash: request.txHash,
        walletId: request.walletId,
        status: TransactionStatus.fromJson(request.status),
        requester: request.requester.toJson(),
        requestBody: request.requestBody.toJson(),
        metadata: request.metadata ?? {},
        dateRequested: request.dateRequested,
        dateConfirmed: request.dateConfirmed,
        dateBroadcasted: request.dateBroadcasted,
        network: request.network,
        reason: request.reason,
      );
}
