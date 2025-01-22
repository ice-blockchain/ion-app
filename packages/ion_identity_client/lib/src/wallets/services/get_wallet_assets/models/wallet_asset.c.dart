// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion_identity_client/src/core/types/types.dart';

part 'wallet_asset.c.freezed.dart';
part 'wallet_asset.c.g.dart';

/// Provided by 3d party service.
///
/// [balance] can be very small or big value, so should be converted to double or BigInt
@freezed
class WalletAsset with _$WalletAsset {
  const factory WalletAsset({
    required String? name,
    required String? contract,
    required String symbol,
    required int decimals,
    required String balance,
    required bool? verified,
  }) = _WalletAsset;

  factory WalletAsset.fromJson(JsonObject json) => _$WalletAssetFromJson(json);
}
