// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/inputs/search_input/search_input.dart';
import 'package:ice/app/features/wallet/providers/filtered_assets_provider.dart';
import 'package:ice/app/features/wallet/providers/hooks/use_filtered_wallet_coins.dart';
import 'package:ice/app/features/wallet/providers/hooks/use_filtered_wallet_nfts.dart';
import 'package:ice/app/features/wallet/views/pages/wallet_page/providers/search_visibility_provider.dart';
import 'package:ice/app/features/wallet/views/pages/wallet_page/tab_type.dart';

class WalletSearchBar extends HookConsumerWidget {
  const WalletSearchBar({
    required this.tabType,
    super.key,
    this.padding = EdgeInsets.zero,
  });

  final WalletTabType tabType;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final coinsResult = useFilteredWalletCoins(ref);
    final nftsResult = useFilteredWalletNfts(ref);

    final isLoading = coinsResult.isLoading || nftsResult.isLoading;

    final searchVisibleProvider = walletSearchVisibilityProvider(tabType);
    final searchQueryProvider = walletSearchQueryControllerProvider(tabType.walletAssetType);

    final isSearchVisible = ref.watch(searchVisibleProvider);

    if (!isSearchVisible) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: padding,
      child: SearchInput(
        loading: isLoading,
        onTextChanged: (String newValue) {
          ref.read(searchQueryProvider.notifier).query = newValue;
        },
        onCancelSearch: () {
          ref.read(searchQueryProvider.notifier).query = '';
          ref.read(searchVisibleProvider.notifier).isVisible = false;
        },
      ),
    );
  }
}
