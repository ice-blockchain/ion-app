// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/extensions/riverpod.dart';
import 'package:ion/app/features/wallets/model/coins_group.c.dart';
import 'package:ion/app/features/wallets/model/wallet_data_with_loading_state.c.dart';
import 'package:ion/app/features/wallets/providers/coins_provider.c.dart';
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
    final searchQueryListener = ref.listen<String>(
      walletSearchQueryControllerProvider(WalletAssetType.coin),
      (previous, next) => search(next),
    );

    ref.onDispose(searchQueryListener.close);

    final coinGroups = await ref.watch(coinsInWalletProvider.future);
    return coinGroups;
  }

  Future<void> search(String query) async {
    await ref.debounce();
    final coinGroups = await ref.watch(coinsInWalletProvider.future);
    final filteredCoins = _filterCoins(coinGroups, query);
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
