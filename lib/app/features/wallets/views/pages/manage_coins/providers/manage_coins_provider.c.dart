// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:collection/collection.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/wallets/data/coins/repository/coins_repository.c.dart';
import 'package:ion/app/features/wallets/model/coin_data.c.dart';
import 'package:ion/app/features/wallets/model/manage_coin_data.c.dart';
import 'package:ion/app/features/wallets/providers/update_wallet_view_provider.c.dart';
import 'package:ion/app/features/wallets/providers/wallet_view_data_provider.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'manage_coins_provider.c.g.dart';

@riverpod
class ManageCoinsNotifier extends _$ManageCoinsNotifier {
  @override
  Future<Map<String, ManageCoinData>> build() async {
    final walletView = await ref.watch(currentWalletViewDataProvider.future);

    final coinsFromWallet = <String, ManageCoinData>{
      for (final coinInWallet in walletView.coins)
        coinInWallet.coin.id: ManageCoinData(
          coin: coinInWallet.coin,
          isSelected: state.value?[coinInWallet.coin.id]?.isSelected ?? true,
        ),
    };

    return coinsFromWallet;
  }

  void switchCoin({required CoinData coin}) {
    final currentMap = state.value ?? <String, ManageCoinData>{};
    currentMap[coin.id] = ManageCoinData(
      coin: coin,
      isSelected: !(currentMap[coin.id]?.isSelected ?? false),
    );
    state = AsyncData<Map<String, ManageCoinData>>(currentMap);
  }

  Future<void> save() async {
    final updatedCoins = state.value?.values
            .where((manageCoin) => manageCoin.isSelected)
            .map((manageCoin) => manageCoin.coin)
            .toList() ??
        [];
    final currentWalletView = await ref.read(currentWalletViewDataProvider.future);

    final updateRequired = !(const ListEquality<CoinData>().equals(
      updatedCoins,
      currentWalletView.coins.map((e) => e.coin).toList(),
    ));
    if (updateRequired) {
      unawaited(
        ref.read(updateWalletViewNotifierProvider.notifier).updateWalletView(
              walletView: currentWalletView,
              updatedCoinsList: updatedCoins,
            ),
      );
    }
  }
}

@riverpod
class SearchCoinsNotifier extends _$SearchCoinsNotifier {
  @override
  Future<Set<CoinData>> build() async => {};

  Future<void> search({required String query}) async {
    if (query.isEmpty) {
      state = ref.read(manageCoinsNotifierProvider).map(
            data: (data) => AsyncData(
              data.value.values.map((manageCoin) => manageCoin.coin).toSet(),
            ),
            error: (error) => AsyncError(error.error, error.stackTrace),
            loading: (loading) => const AsyncLoading(),
          );
      return;
    }

    await ref.debounce();

    final repository = ref.read(coinsRepositoryProvider);
    final searchResult = await repository
        .searchCoins(query)
        .then((result) => result.map(CoinData.fromDB)); // TODO: (1) Move converting to the repo?

    state = ref.read(manageCoinsNotifierProvider).maybeWhen(
          data: (coinsInWalletView) {
            final coinsInWallet =
                coinsInWalletView.values.map((coinInWallet) => coinInWallet.coin).toList();

            // Coins from wallet should be first in the search results list
            final result = <CoinData>{};
            for (final coinInWallet in coinsInWallet) {
              if (searchResult.contains(coinInWallet)) {
                result.add(coinInWallet);
              }
            }
            result.addAll(searchResult);

            return AsyncData(result);
          },
          orElse: () => const AsyncLoading(),
        );
  }
}
