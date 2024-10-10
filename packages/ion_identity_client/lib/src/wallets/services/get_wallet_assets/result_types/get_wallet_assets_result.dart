// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion_identity_client/src/wallets/services/get_wallet_assets/dtos/wallet_assets_dto.dart';

part 'get_wallet_assets_result.freezed.dart';

@freezed
class GetWalletAssetsResult with _$GetWalletAssetsResult {
  factory GetWalletAssetsResult.success(
    WalletAssetsDto walletAssets,
  ) = _GetWalletAssetsSuccess;

  factory GetWalletAssetsResult.failure(
    GetWalletAssetsFailure failure,
  ) = _GetWalletAssetsFailure;
}

@freezed
class GetWalletAssetsFailure with _$GetWalletAssetsFailure {
  factory GetWalletAssetsFailure([
    Object? error,
    StackTrace? stackTrace,
  ]) = _GetWalletAssetsFailureInternal;
}
