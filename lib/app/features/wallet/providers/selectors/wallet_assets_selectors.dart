import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/features/wallet/model/coin_data.dart';
import 'package:ice/app/features/wallet/model/nft_data.dart';
import 'package:ice/app/features/wallet/model/wallet_data_with_loading_state.dart';
import 'package:ice/app/features/wallet/providers/coins_provider.dart';
import 'package:ice/app/features/wallet/providers/nfts_provider.dart';

List<CoinData> coinsDataSelector(WidgetRef ref) {
  return ref.watch(
    coinsNotifierProvider.select(
      (AsyncValue<List<CoinData>> data) => data.value ?? <CoinData>[],
    ),
  );
}

bool combinedIsLoadingSelector(WidgetRef ref) {
  final coinsLoading = ref.watch(
    coinsNotifierProvider.select(
      (AsyncValue<List<CoinData>> data) => data.isLoading,
    ),
  );

  final nftsLoading = ref.watch(
    nftsNotifierProvider.select(
      (AsyncValue<List<NftData>> data) => data.isLoading,
    ),
  );

  return coinsLoading || nftsLoading;
}

bool coinsIsLoadingSelector(WidgetRef ref) {
  return ref.watch(
    coinsNotifierProvider.select(
      (AsyncValue<List<CoinData>> data) => data.isLoading,
    ),
  );
}

List<NftData> nftsDataSelector(WidgetRef ref) {
  return ref.watch(
    nftsNotifierProvider.select(
      (AsyncValue<List<NftData>> data) => data.value ?? <NftData>[],
    ),
  );
}

bool nftsIsLoadingSelector(WidgetRef ref) {
  return ref.watch(
    nftsNotifierProvider.select(
      (AsyncValue<List<NftData>> data) => data.isLoading,
    ),
  );
}

bool walletAssetIsLoadingSelector({
  required WidgetRef ref,
  required WalletAssetType assetType,
}) {
  return switch (assetType) {
    WalletAssetType.coin => coinsIsLoadingSelector(ref),
    WalletAssetType.nft => nftsIsLoadingSelector(ref),
  };
}
