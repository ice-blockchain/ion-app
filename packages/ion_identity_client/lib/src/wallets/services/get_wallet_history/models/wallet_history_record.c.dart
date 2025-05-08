// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion_identity_client/src/wallets/services/get_wallet_history/models/wallet_history_metadata.c.dart';

part 'wallet_history_record.c.freezed.dart';
part 'wallet_history_record.c.g.dart';

@freezed
class WalletHistoryRecord with _$WalletHistoryRecord {
  const factory WalletHistoryRecord({
    required String walletId,
    required String network,
    required String kind,
    required String direction,
    required int blockNumber,
    required DateTime timestamp,
    required String txHash,
    required String? externalHash,
    required String? index,
    required String? contract,
    required String? tokenId,
    required String? from,
    required String? to,
    required List<String>? tos,
    required List<String>? froms,
    required String? value,
    required String? fee,
    required WalletHistoryMetadata metadata,
  }) = _WalletHistoryRecord;

  factory WalletHistoryRecord.fromJson(Map<String, dynamic> json) =>
      _$WalletHistoryRecordFromJson(json);
}
