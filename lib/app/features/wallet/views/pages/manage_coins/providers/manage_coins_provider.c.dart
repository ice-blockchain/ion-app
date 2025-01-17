// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/wallet/views/pages/manage_coins/model/manage_coin_in_wallet.c.dart';
import 'package:ion/app/features/wallets/providers/current_user_wallet_views_provider.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'manage_coins_provider.c.g.dart';

@Riverpod(keepAlive: true)
class ManageCoinsNotifier extends _$ManageCoinsNotifier {
  @override
  AsyncValue<Map<String, ManageCoinInWallet>> build() {
    // TODO: Probably, this provider is for managing coins that are already in the wallet.
    // If not, it needs to be fixed so that it works with CoinData.

    final walletView = ref.watch(currentUserWalletViewsProvider);

    return walletView.when(
      data: (walletView) {
        final coinsFromWallet = <String, ManageCoinInWallet>{
          for (final coinInWallet in walletView.expand((wallet) => wallet.coins))
            coinInWallet.coin.id: ManageCoinInWallet(
              coinInWallet: coinInWallet,
              isSelected: state.value?[coinInWallet.coin.id]?.isSelected ?? false,
            ),
        };

        return AsyncData(coinsFromWallet);
      },
      loading: () => const AsyncLoading(),
      error: AsyncError.new,
    );
  }

  void switchCoin({required String coinId}) {
    final currentMap = state.value ?? <String, ManageCoinInWallet>{};

    if (currentMap.containsKey(coinId)) {
      final updatedCoin = currentMap[coinId]!.copyWith(
        isSelected: !currentMap[coinId]!.isSelected,
      );

      state = AsyncData<Map<String, ManageCoinInWallet>>(
        {...currentMap, coinId: updatedCoin},
      );
    }
  }
}

@Riverpod(keepAlive: true)
class FilteredCoinsNotifier extends _$FilteredCoinsNotifier {
  @override
  AsyncValue<List<ManageCoinInWallet>> build({required String searchText}) {
    return const AsyncLoading();
  }

  Future<void> filter({required String searchText}) async {
    state = const AsyncLoading();

    await Future<void>.delayed(const Duration(seconds: 1));

    final allCoinsState = ref.read(manageCoinsNotifierProvider);

    state = allCoinsState.maybeWhen(
      data: (allCoinsMap) {
        final allCoins = allCoinsMap.values.toList();
        final query = searchText.trim().toLowerCase();

        if (query.isEmpty) {
          return AsyncData(allCoins);
        }

        final filteredCoins = allCoins
            .where((coin) => coin.coinInWallet.coin.name.toLowerCase().contains(query))
            .toList();

        return AsyncData(filteredCoins);
      },
      orElse: () => const AsyncLoading(),
    );
  }
}

@Riverpod(keepAlive: true)
AsyncValue<List<ManageCoinInWallet>> selectedCoins(Ref ref) {
  final allCoinsMap = ref.watch(manageCoinsNotifierProvider).value ?? {};
  final selected = allCoinsMap.values.where((coin) => coin.isSelected).toList();
  return AsyncData<List<ManageCoinInWallet>>(selected);
}
