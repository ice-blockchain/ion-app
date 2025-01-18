// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/wallet/data/coins/domain/coins_mapper.dart';
import 'package:ion/app/features/wallet/data/coins/repository/coins_repository.c.dart';
import 'package:ion/app/features/wallet/views/pages/manage_coins/model/manage_coin_data.c.dart';
import 'package:ion/app/features/wallets/providers/current_user_wallet_views_provider.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'manage_coins_provider.c.g.dart';

@Riverpod(keepAlive: true)
class ManageCoinsNotifier extends _$ManageCoinsNotifier {
  @override
  AsyncValue<Map<String, ManageCoinData>> build() {
    final walletView = ref.watch(currentUserWalletViewsProvider);

    return walletView.when(
      data: (walletView) {
        final coinsFromWallet = <String, ManageCoinData>{
          for (final coinInWallet in walletView.expand((wallet) => wallet.coins))
            coinInWallet.coin.id: ManageCoinData(
              coin: coinInWallet.coin,
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
    final currentMap = state.value ?? <String, ManageCoinData>{};

    if (currentMap.containsKey(coinId)) {
      final updatedCoin = currentMap[coinId]!.copyWith(
        isSelected: !currentMap[coinId]!.isSelected,
      );

      state = AsyncData<Map<String, ManageCoinData>>(
        {...currentMap, coinId: updatedCoin},
      );
    }
  }
}

@Riverpod(keepAlive: true)
AsyncValue<List<ManageCoinData>> selectedCoins(Ref ref) {
  final allCoinsMap = ref.watch(manageCoinsNotifierProvider).value ?? {};
  final selected = allCoinsMap.values.where((coin) => coin.isSelected).toList();
  return AsyncData<List<ManageCoinData>>(selected);
}

@riverpod
class SearchCoinsNotifier extends _$SearchCoinsNotifier {
  @override
  AsyncValue<Set<ManageCoinData>> build() => const AsyncLoading();

  Future<void> search({required String query}) async {

    if (query.isEmpty) {
      state = ref.read(manageCoinsNotifierProvider).map(
        data: (data) => AsyncData(data.value.values.toSet()),
        error: (error) => AsyncError(error.error, error.stackTrace),
        loading: (loading) => const AsyncLoading(),
      );
      return;
    }

    await ref.debounce();

    final repository = ref.read(coinsRepositoryProvider);
    final searchResult = await repository
        .searchCoins(query)
        .then(CoinsMapper.fromDbToDomain); // TODO: Move converting to the repo?

    state = ref.read(manageCoinsNotifierProvider).maybeWhen(
      data: (coinsInWalletView) {
        final coinsInWallet = coinsInWalletView.values.toList();

        final result = <ManageCoinData>{};
        for (final manageCoin in coinsInWallet) {
          if (searchResult.contains(manageCoin.coin)) {
            result.add(manageCoin);
          }
        }
        result.addAll(
          searchResult.map(
            (coin) => ManageCoinData(coin: coin, isSelected: false),
          ),
        );

        return AsyncData(result);
      },
      orElse: () => const AsyncLoading(),
    );
  }
}
