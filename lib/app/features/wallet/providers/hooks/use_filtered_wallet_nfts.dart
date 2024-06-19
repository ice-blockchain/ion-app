import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/features/user/providers/user_preferences_selectors.dart';
import 'package:ice/app/features/wallet/model/nft_data.dart';
import 'package:ice/app/features/wallet/providers/selectors/wallet_assets_selectors.dart';

List<NftData> useFilteredWalletNfts(WidgetRef ref) {
  final isZeroValueAssetsVisible = isZeroValueAssetsVisibleSelector(ref);
  final walletNfts = nftsDataSelector(ref);

  return useMemoized(
    () {
      return isZeroValueAssetsVisible
          ? walletNfts
          : walletNfts.where((NftData nft) => nft.price > 0.00).toList();
    },
    <Object?>[isZeroValueAssetsVisible, walletNfts],
  );
}
