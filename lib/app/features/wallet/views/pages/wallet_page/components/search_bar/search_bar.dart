import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/search_input/search_input.dart';
import 'package:ice/app/features/wallet/model/wallet_data_with_loading_state.dart';
import 'package:ice/app/features/wallet/providers/wallet_data_selectors.dart';
import 'package:ice/app/features/wallet/views/pages/wallet_page/providers/wallet_page_provider.dart';
import 'package:ice/app/features/wallet/views/pages/wallet_page/providers/wallet_page_selectors.dart';
import 'package:ice/app/features/wallet/views/pages/wallet_page/tab_type.dart';

class WalletSearchBar extends HookConsumerWidget {
  const WalletSearchBar({
    super.key,
    required this.tabType,
    this.padding = EdgeInsets.zero,
  });

  final WalletTabType tabType;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final WalletAssetType assetType = tabType.walletAssetType;
    final String defaultSearchValue =
        walletAssetSearchValueSelector(ref, tabType);
    final bool isLoading = walletAssetIsLoadingSelector(ref, assetType);
    final bool isVisible = walletTabSearchVisibleSelector(ref, tabType);

    if (isVisible == false) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: padding,
      child: SearchInput(
        defaultValue: defaultSearchValue,
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
