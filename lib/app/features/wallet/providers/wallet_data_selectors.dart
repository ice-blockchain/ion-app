import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/features/wallet/model/coin_data.dart';
import 'package:ice/app/features/wallet/model/nft_data.dart';
import 'package:ice/app/features/wallet/model/wallet_data_with_loading_state.dart';
import 'package:ice/app/features/wallet/providers/wallet_data_provider.dart';

double walletBalanceSelector(WidgetRef ref) {
  return ref.watch(
    walletDataNotifierProvider.select(
      (WalletDataWithLoadingState walletData) => walletData.walletData.balance,
    ),
  );
}

String walletNameSelector(WidgetRef ref) {
  return ref.watch(
    walletDataNotifierProvider.select(
      (WalletDataWithLoadingState walletData) => walletData.walletData.name,
    ),
  );
}

String walletIconSelector(WidgetRef ref) {
  return ref.watch(
    walletDataNotifierProvider.select(
      (WalletDataWithLoadingState walletData) => walletData.walletData.icon,
    ),
  );
}

List<CoinData> walletCoinsSelector(WidgetRef ref) {
  return ref.watch(
    walletDataNotifierProvider.select(
      (WalletDataWithLoadingState walletData) => walletData.walletData.coins,
    ),
  );
}

List<NftData> walletNftsSelector(WidgetRef ref) {
  return ref.watch(
    walletDataNotifierProvider.select(
      (WalletDataWithLoadingState walletData) => walletData.walletData.nfts,
    ),
  );
}

String walletAssetSearchValueSelector(
  WidgetRef ref,
  WalletAssetType assetType,
) {
  return ref.watch(
    walletDataNotifierProvider.select(
      (WalletDataWithLoadingState walletData) =>
          walletData.assetSearchValues[assetType] ?? '',
    ),
  );
}

bool walletAssetIsLoadingSelector(WidgetRef ref, WalletAssetType assetType) {
  return ref.watch(
    walletDataNotifierProvider.select(
      (WalletDataWithLoadingState walletData) =>
          walletData.loadingAssets[assetType]?.isLoading ?? false,
    ),
  );
}
