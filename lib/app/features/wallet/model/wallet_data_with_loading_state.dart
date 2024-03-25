import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ice/app/features/wallet/model/wallet_data.dart';

part 'wallet_data_with_loading_state.freezed.dart';

enum WalletAssetType { nft, coin }

@Freezed(copyWith: true)
class WalletDataWithLoadingState with _$WalletDataWithLoadingState {
  const factory WalletDataWithLoadingState({
    required WalletData walletData,
    required Set<WalletAssetType> loadingAssets,
    required Map<WalletAssetType, String> assetSearchValues,
  }) = _WalletDataWithLoadingState;
}
