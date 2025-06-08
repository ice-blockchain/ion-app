// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/extensions/riverpod.dart';
import 'package:ion/app/features/wallets/data/models/coins_group.c.dart';
import 'package:ion/app/features/wallets/data/models/wallet_data_with_loading_state.c.dart';
import 'package:ion/app/features/wallets/providers/coins_provider.c.dart';
import 'package:ion/app/features/wallets/views/pages/manage_coins/providers/manage_coins_provider.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'filtered_assets_provider.c.g.dart';

const apiCallDelay = Duration(milliseconds: 500);

@Riverpod(keepAlive: true)
class WalletSearchQueryController extends _$WalletSearchQueryController {
  @override
  String build(WalletAssetType assetType) => '';

  set query(String query) => state = query;
}

@riverpod
class FilteredCoinsNotifier extends _$FilteredCoinsNotifier {
  @override
  Future<List<CoinsGroup>> build() async {
    final manageCoinsNotifier = ref.watch(manageCoinsNotifierProvider);
    final selectedCoins = manageCoinsNotifier.value;

    final searchQueryListener = ref.listen<String>(
      walletSearchQueryControllerProvider(WalletAssetType.coin),
      (previous, next) => search(next),
    );

    ref.onDispose(searchQueryListener.close);

    final coinGroups = await ref.watch(coinsInWalletProvider.future);

    if (selectedCoins != null) {
      final newlyAddedGroups = selectedCoins.values
          .where((group) => group.isNewlyAdded)
          .map((group) => group.coinsGroup)
          .toList();

      if (newlyAddedGroups.isNotEmpty) {
        return [...coinGroups, ...newlyAddedGroups];
      }
    }

    return coinGroups;
  }

  Future<void> search(String query) async {
    await ref.debounce();
    final coinGroups = await ref.watch(coinsInWalletProvider.future);
    final manageCoinsNotifier = ref.watch(manageCoinsNotifierProvider);

    final newlyAddedGroups = manageCoinsNotifier.value?.values
            .where((group) => group.isNewlyAdded)
            .map((group) => group.coinsGroup)
            .toList() ??
        [];

    final allCoins = [...coinGroups, ...newlyAddedGroups];

    final filteredCoins = _filterCoins(allCoins, query);
    state = AsyncData(filteredCoins);
  }
}

List<CoinsGroup> _filterCoins(List<CoinsGroup> coins, String query) {
  if (query.isEmpty) {
    return coins;
  }
  return coins
      .where(
        (group) =>
            group.name.toLowerCase().contains(query) ||
            group.abbreviation.toLowerCase().contains(query),
      )
      .toList();
}
