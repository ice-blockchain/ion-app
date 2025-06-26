// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion_identity_client/src/wallets/services/get_wallet_history/models/wallet_history_record.f.dart';

part 'wallet_history.f.freezed.dart';
part 'wallet_history.f.g.dart';

@freezed
class WalletHistory with _$WalletHistory {
  const factory WalletHistory({
    required List<WalletHistoryRecord> items,
    String? nextPageToken,
  }) = _WalletHistory;

  factory WalletHistory.fromJson(Map<String, dynamic> json) => _$WalletHistoryFromJson(json);
}
