import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/features/wallet/views/pages/wallet_page/providers/model/wallet_page_provider_data.dart';
import 'package:ice/app/features/wallet/views/pages/wallet_page/tab_type.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'wallet_page_provider.g.dart';

@riverpod
class WalletPageNotifier extends _$WalletPageNotifier {
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
    state = state.copyWith(
      tabSearchVisibleMap:
          Map<WalletTabType, bool>.from(state.tabSearchVisibleMap)
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
    required WidgetRef ref,
  }) {
    state = state.copyWith(
      assetSearchValues:
          Map<WalletTabType, String>.from(state.assetSearchValues)
            ..update(
              tabType,
              (_) => searchValue,
              ifAbsent: () => searchValue,
            ),
    );
  }
}
