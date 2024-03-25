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
}
