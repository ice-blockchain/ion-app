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
import 'package:ion/app/features/wallets/views/pages/manage_coins/models/manage_coins_state.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'manage_coins_provider.c.g.dart';

@riverpod
class ManageCoinsNotifier extends _$ManageCoinsNotifier {
  static const _pageSize = 20;

  final _coinsFromWallet = <String, ManageCoinsGroup>{};
  final _loadedCoins = <String, ManageCoinsGroup>{};
  final _toExclude = <String>{};
  var _coinGroupsNumber = 0;

  @override
  Future<ManageCoinsState> build() async {
    final walletView = await ref.watch(currentWalletViewDataProvider.future);

    for (final coinGroup in walletView.coinGroups) {
      _toExclude.addAll(coinGroup.coins.map((e) => e.coin.id));
      _coinsFromWallet[coinGroup.symbolGroup] = ManageCoinsGroup(
        coinsGroup: coinGroup,
        isSelected: state.value?.groups[coinGroup.symbolGroup]?.isSelected ?? true,
      );
    }
    final coinsService = await ref.watch(coinsServiceProvider.future);

    if (_coinGroupsNumber == 0) {
      _coinGroupsNumber = await coinsService.getCoinGroupsNumber();
    }

    if (_coinsFromWallet.length < _pageSize) {
      final repo = await ref.watch(coinsServiceProvider.future);
      final groups = await repo.getCoinGroups(
        limit: _pageSize - _coinsFromWallet.length,
        excludeCoinIds: _toExclude,
      );
      _loadedCoins.addAll({
        for (final group in groups)
          group.symbolGroup: ManageCoinsGroup(
            coinsGroup: group,
            isSelected: state.value?.groups[group.symbolGroup]?.isSelected ?? false,
          ),
      });
    }

    final groups = {
      ..._coinsFromWallet,
      ..._loadedCoins,
    };

    return ManageCoinsState(
      hasMore: groups.length < _coinGroupsNumber,
      groups: groups,
    );
  }

  void switchCoinsGroup(CoinsGroup coinsGroup) {
    final stateMap = state.value?.groups;
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
    // state = AsyncData<Map<String, ManageCoinsGroup>>(currentMap);
    state = AsyncData<ManageCoinsState>(
      ManageCoinsState(
        hasMore: _coinGroupsNumber > currentMap.length,
        groups: currentMap,
      ),
    );
  }

  Future<void> save() async {
    final currentWalletView = await ref.read(currentWalletViewDataProvider.future);
    final updatedCoins = state.value?.groups.values
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

  Future<void> loadMore() async {
    final repo = await ref.watch(coinsServiceProvider.future);
    final loadedGroups = await repo.getCoinGroups(
      limit: _pageSize,
      offset: _loadedCoins.length,
      excludeCoinIds: _toExclude,
    );
    _loadedCoins.addAll({
      for (final group in loadedGroups)
        group.symbolGroup: ManageCoinsGroup(
          coinsGroup: group,
          isSelected: state.value?.groups[group.symbolGroup]?.isSelected ?? false,
        ),
    });
    final groups = {
      ..._coinsFromWallet,
      ..._loadedCoins,
    };
    state = AsyncData<ManageCoinsState>(
      ManageCoinsState(
        hasMore: _coinGroupsNumber > groups.length,
        groups: groups,
      ),
    );
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
              data.value.groups.values.map((manageCoin) => manageCoin.coinsGroup).toSet(),
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
            final walletCoinGroups = coinsInWalletView.groups.values
                .map((manageGroup) => manageGroup.coinsGroup)
                .toList();

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
