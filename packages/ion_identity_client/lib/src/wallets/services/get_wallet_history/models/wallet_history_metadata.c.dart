// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion_identity_client/src/wallets/services/get_wallet_history/models/wallet_history_asset_metadata.c.dart';

part 'wallet_history_metadata.c.freezed.dart';
part 'wallet_history_metadata.c.g.dart';

@freezed
class WalletHistoryMetadata with _$WalletHistoryMetadata {
  const factory WalletHistoryMetadata({
    required WalletHistoryAssetMetadata asset,
    required WalletHistoryAssetMetadata fee,
  }) = _WalletHistoryMetadata;

  factory WalletHistoryMetadata.fromJson(Map<String, dynamic> json) =>
      _$WalletHistoryMetadataFromJson(json);
}
