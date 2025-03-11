// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/features/wallets/model/transfer_status.c.dart';

part 'transfer_result.c.freezed.dart';
part 'transfer_result.c.g.dart';

@freezed
class TransferResult with _$TransferResult {
  const factory TransferResult({
    required String id,
    required String? txHash,
    required String walletId,
    required TransferStatus status,
    required Map<String, dynamic> requester,
    required Map<String, dynamic> requestBody,
    required Map<String, dynamic> metadata,
    required DateTime dateRequested,
    required DateTime? dateConfirmed,
    required DateTime? dateBroadcasted,
    required String network,
    required String? reason,
  }) = _TransferResult;

  factory TransferResult.fromJson(Map<String, dynamic> json) => _$TransferResultFromJson(json);
}
