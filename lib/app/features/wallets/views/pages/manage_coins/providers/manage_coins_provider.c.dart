// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:collection/collection.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/wallets/domain/coins/coins_service.c.dart';
import 'package:ion/app/features/wallets/domain/coins/search_coins_service.c.dart';
import 'package:ion/app/features/wallets/model/coin_data.c.dart';
import 'package:ion/app/features/wallets/model/coins_group.c.dart';
import 'package:ion/app/features/wallets/model/manage_coins_group.c.dart';
import 'package:ion/app/features/wallets/providers/update_wallet_view_provider.c.dart';
import 'package:ion/app/features/wallets/providers/wallet_view_data_provider.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'manage_coins_provider.c.g.dart';
part 'required_coin_groups_list.dart';

@riverpod
class ManageCoinsNotifier extends _$ManageCoinsNotifier {
  final _coinsFromWallet = <String, ManageCoinsGroup>{};
  final _loadedGroups = <String, ManageCoinsGroup>{};
  final _toExclude = <String>{};

  @override
  Future<Map<String, ManageCoinsGroup>> build() async {
    final walletView = await ref.watch(currentWalletViewDataProvider.future);

    for (final coinGroup in walletView.coinGroups) {
      _toExclude.addAll(coinGroup.coins.map((e) => e.coin.id));
      _coinsFromWallet[coinGroup.symbolGroup] = ManageCoinsGroup(
        coinsGroup: coinGroup,
        isSelected: state.value?[coinGroup.symbolGroup]?.isSelected ?? true,
        isUpdating: false,
      );
    }
    final coinsService = await ref.watch(coinsServiceProvider.future);
    final loadedGroups = await coinsService.getCoinGroups(
      symbolGroups: _coinGroups,
      excludeCoinIds: _toExclude,
    );
    _loadedGroups.addAll({
      for (final group in loadedGroups)
        group.symbolGroup: ManageCoinsGroup(
          coinsGroup: group,
          isSelected: state.value?[group.symbolGroup]?.isSelected ?? false,
          isUpdating: false,
        ),
    });

    final groups = {
      ..._coinsFromWallet,
      ..._loadedGroups,
    };

    return groups;
  }

  void switchCoinsGroup(CoinsGroup coinsGroup) {
    final stateMap = state.value;
    final currentMap = stateMap != null
        ? Map<String, ManageCoinsGroup>.from(stateMap)
        : <String, ManageCoinsGroup>{};
    final currentGroup = currentMap[coinsGroup.symbolGroup];
    final isNewlyAdded = !currentMap.containsKey(coinsGroup.symbolGroup);
    final isBeingDeleted = currentGroup?.isSelected ?? false;

    currentMap[coinsGroup.symbolGroup] = ManageCoinsGroup(
      coinsGroup: coinsGroup,
      isSelected: !(currentGroup?.isSelected ?? false),
      isUpdating: isNewlyAdded || isBeingDeleted,
    );
    state = AsyncData(currentMap);
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
