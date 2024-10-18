// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/wallet/model/wallet_data.dart';

part 'wallet_data_with_loading_state.freezed.dart';

enum WalletAssetType { nft, coin }

@freezed
class WalletDataWithLoadingState with _$WalletDataWithLoadingState {
  const factory WalletDataWithLoadingState({
    required WalletData walletData,
    required Map<WalletAssetType, AsyncValue<bool>> loadingAssets,
  }) = _WalletDataWithLoadingState;
}
