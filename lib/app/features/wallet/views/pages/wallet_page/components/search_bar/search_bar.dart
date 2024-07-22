import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/inputs/search_input/search_input.dart';
import 'package:ice/app/features/wallet/providers/selectors/wallet_assets_selectors.dart';
import 'package:ice/app/features/wallet/views/pages/wallet_page/providers/wallet_page_provider.dart';
import 'package:ice/app/features/wallet/views/pages/wallet_page/providers/wallet_page_selectors.dart';
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
    final assetType = tabType.walletAssetType;
    final defaultValue = walletAssetSearchValueSelector(ref, tabType);
    final isLoading = walletAssetIsLoadingSelector(ref: ref, assetType: assetType);
    final isVisible = walletTabSearchVisibleSelector(ref, tabType);

    if (isVisible == false) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: padding,
      child: SearchInput(
        defaultValue: defaultValue,
        loading: isLoading,
        onTextChanged: (String newValue) {
          ref.read(walletPageNotifierProvider.notifier).updateSearchValue(
                searchValue: newValue,
                tabType: tabType,
                ref: ref,
              );
        },
        onCancelSearch: () {
          ref
              .read(walletPageNotifierProvider.notifier)
              .updateSearchVisible(tabType: tabType, isSearchVisible: false);
        },
      ),
    );
  }
}
