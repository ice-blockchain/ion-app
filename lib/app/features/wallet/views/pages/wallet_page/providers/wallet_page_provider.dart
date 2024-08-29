import 'dart:async';

import 'package:ice/app/features/wallet/views/pages/wallet_page/providers/model/wallet_page_provider_data.dart';
import 'package:ice/app/features/wallet/views/pages/wallet_page/tab_type.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'wallet_page_provider.g.dart';

@Riverpod(keepAlive: true)
class WalletPageNotifier extends _$WalletPageNotifier {
  Timer? _debounce;

  @override
  WalletPageProviderData build() {
    return const WalletPageProviderData(
      tabSearchVisibleMap: <WalletTabType, bool>{},
      assetSearchValues: <WalletTabType, String>{},
    );
  }

  void updateSearchVisible({
    required WalletTabType tabType,
    required bool isSearchVisible,
  }) {
    if (state.tabSearchVisibleMap[tabType] == isSearchVisible) {
      return;
    }

    state = state.copyWith(
      tabSearchVisibleMap: Map<WalletTabType, bool>.from(state.tabSearchVisibleMap)
        ..update(
          tabType,
          (_) => isSearchVisible,
          ifAbsent: () => isSearchVisible,
        ),
    );
  }

  void updateSearchValue({
    required String searchValue,
    required WalletTabType tabType,
  }) {
    if (state.assetSearchValues[tabType] == searchValue) {
      return;
    }

    _debounce?.cancel();

    _debounce = Timer(const Duration(milliseconds: 300), () {
      state = state.copyWith(
        assetSearchValues: Map<WalletTabType, String>.from(state.assetSearchValues)
          ..update(
            tabType,
            (_) => searchValue,
            ifAbsent: () => searchValue,
          ),
      );
    });
  }
}
