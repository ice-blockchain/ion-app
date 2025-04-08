// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';

part 'wallet_history_asset_metadata.c.freezed.dart';
part 'wallet_history_asset_metadata.c.g.dart';

@freezed
class WalletHistoryAssetMetadata with _$WalletHistoryAssetMetadata {
  const factory WalletHistoryAssetMetadata({
    required String symbol,
    required int? decimals,
    required bool? verified,
  }) = _WalletHistoryAssetMetadata;

  factory WalletHistoryAssetMetadata.fromJson(Map<String, dynamic> json) =>
      _$WalletHistoryAssetMetadataFromJson(json);
}
