// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion_identity_client/src/core/types/types.dart';
import 'package:ion_identity_client/src/wallets/services/get_wallet_assets/models/wallet_asset.f.dart';

part 'wallet_assets.f.freezed.dart';
part 'wallet_assets.f.g.dart';

@freezed
class WalletAssets with _$WalletAssets {
  factory WalletAssets({
    required String walletId,
    required String network,
    required List<WalletAsset> assets,
  }) = _WalletAssets;

  factory WalletAssets.fromJson(JsonObject json) => _$WalletAssetsFromJson(json);
}
