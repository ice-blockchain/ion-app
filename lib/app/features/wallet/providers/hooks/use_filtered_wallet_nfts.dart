import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/features/wallet/model/nft_data.dart';
import 'package:ice/app/features/wallet/providers/filtered_assets_provider.dart';
import 'package:ice/app/features/wallet/providers/wallet_user_preferences/user_preferences_selectors.dart';

typedef FilteredNftsResult = ({List<NftData> nfts, bool isLoading});

FilteredNftsResult useFilteredWalletNfts(WidgetRef ref) {
  final isZeroValueAssetsVisible = ref.watch(isZeroValueAssetsVisibleSelectorProvider);

  final AsyncValue<List<NftData>> nftsState = ref.watch(filteredNftsProvider);

  final walletNfts = nftsState.valueOrNull ?? <NftData>[];
  final isLoading = nftsState.isLoading;

  final filteredNfts = useMemoized(
    () {
      return isZeroValueAssetsVisible
          ? walletNfts
          : walletNfts.where((NftData nft) => nft.price > 0.00).toList();
    },
    [isZeroValueAssetsVisible, walletNfts],
  );

  return (nfts: filteredNfts, isLoading: isLoading);
}
