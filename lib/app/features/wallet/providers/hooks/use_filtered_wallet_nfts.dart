import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/features/user/providers/user_preferences_selectors.dart';
import 'package:ice/app/features/wallet/model/nft_data.dart';
import 'package:ice/app/features/wallet/providers/nfts_provider.dart';

List<NftData> useFilteredWalletNfts(WidgetRef ref) {
  final isZeroValueAssetsVisible = isZeroValueAssetsVisibleSelector(ref);

  final searchResults = ref.watch(nftsNotifierProvider);

  final walletNfts = ref.watch(
    nftsNotifierProvider.select(
      (AsyncValue<List<NftData>> data) => data.value ?? <NftData>[],
    ),
  );

  return useMemoized(
    () {
      return isZeroValueAssetsVisible
          ? walletNfts
          : walletNfts.where((NftData nft) => nft.price > 0.00).toList();
    },
    <Object?>[isZeroValueAssetsVisible, walletNfts, searchResults.isLoading],
  );
}
