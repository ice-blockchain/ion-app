// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/wallets/model/crypto_asset_type.dart';
import 'package:ion/app/features/wallets/model/wallet_view_data.f.dart';

part 'wallet_data_with_loading_state.f.freezed.dart';

@freezed
class WalletDataWithLoadingState with _$WalletDataWithLoadingState {
  const factory WalletDataWithLoadingState({
    required WalletViewData walletData,
    required Map<CryptoAssetType, AsyncValue<bool>> loadingAssets,
  }) = _WalletDataWithLoadingState;
}
