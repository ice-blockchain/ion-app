// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:collection/collection.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/wallets/domain/coins/search_coins_service.c.dart';
import 'package:ion/app/features/wallets/model/coin_data.c.dart';
import 'package:ion/app/features/wallets/model/coins_group.c.dart';
import 'package:ion/app/features/wallets/model/manage_coins_group.c.dart';
import 'package:ion/app/features/wallets/providers/update_wallet_view_provider.c.dart';
import 'package:ion/app/features/wallets/providers/wallet_view_data_provider.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'manage_coins_provider.c.g.dart';

@riverpod
class ManageCoinsNotifier extends _$ManageCoinsNotifier {
  @override
  Future<Map<String, ManageCoinsGroup>> build() async {
    final walletView = await ref.watch(currentWalletViewDataProvider.future);

    final coinsFromWallet = <String, ManageCoinsGroup>{
      for (final coinGroup in walletView.coinGroups)
        coinGroup.symbolGroup: ManageCoinsGroup(
          coinsGroup: coinGroup,
          isSelected: state.value?[coinGroup.symbolGroup]?.isSelected ?? true,
        ),
    };

    return coinsFromWallet;
  }

  void switchCoinsGroup(CoinsGroup coinsGroup) {
    final currentMap = state.value ?? <String, ManageCoinsGroup>{};
    final currentGroup = currentMap[coinsGroup.symbolGroup];
    final isNewlyAdded = !currentMap.containsKey(coinsGroup.symbolGroup);
    final isBeingDeleted = currentGroup?.isSelected ?? false;

    currentMap[coinsGroup.symbolGroup] = ManageCoinsGroup(
      coinsGroup: coinsGroup,
      isSelected: !(currentGroup?.isSelected ?? false),
      isUpdating: isNewlyAdded || isBeingDeleted,
    );
    state = AsyncData<Map<String, ManageCoinsGroup>>(currentMap);
  }

  Future<void> save() async {
    final currentWalletView = await ref.read(currentWalletViewDataProvider.future);
    final updatedCoins = state.value?.values
            .where((manageGroup) => manageGroup.isSelected)
            .expand((manageGroup) => manageGroup.coinsGroup.coins)
            .map((e) => e.coin)
            .toList() ??
        [];

    final walletCoins =
        currentWalletView.coinGroups.expand((e) => e.coins).map((e) => e.coin).toList();

    final updateRequired = !(const ListEquality<CoinData>().equals(updatedCoins, walletCoins));

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
  Future<Set<CoinsGroup>> build() async => {};

  Future<void> search({required String query}) async {
    if (query.isEmpty) {
      state = ref.read(manageCoinsNotifierProvider).map(
            data: (data) => AsyncData(
              data.value.values.map((manageCoin) => manageCoin.coinsGroup).toSet(),
            ),
            error: (error) => AsyncError(error.error, error.stackTrace),
            loading: (loading) => const AsyncLoading(),
          );
      return;
    }

    await ref.debounce();

    final searchService = ref.read(searchCoinsServiceProvider);
    final searchResult = await searchService.search(query).then((coinGroups) {
      return {for (final group in coinGroups) group.symbolGroup: group};
    });
    state = ref.read(manageCoinsNotifierProvider).maybeWhen(
          data: (coinsInWalletView) {
            final walletCoinGroups =
                coinsInWalletView.values.map((manageGroup) => manageGroup.coinsGroup).toList();

            // Coins from wallet should be first in the search results list
            final result = <CoinsGroup>{};
            for (final coinsGroup in walletCoinGroups) {
              final coinsGroupFromWalletView = searchResult[coinsGroup.symbolGroup];
              if (coinsGroupFromWalletView != null) {
                result.add(coinsGroupFromWalletView);
              }
            }
            result.addAll(searchResult.values);

            return AsyncData(result);
          },
          orElse: () => const AsyncLoading(),
        );
  }
}
