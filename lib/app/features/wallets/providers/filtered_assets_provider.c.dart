// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/riverpod.dart';
import 'package:ion/app/features/wallets/model/coins_group.c.dart';
import 'package:ion/app/features/wallets/model/nft_data.c.dart';
import 'package:ion/app/features/wallets/model/wallet_data_with_loading_state.c.dart';
import 'package:ion/app/features/wallets/providers/coins_provider.c.dart';
import 'package:ion/app/features/wallets/providers/nfts_provider.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'filtered_assets_provider.c.g.dart';

const apiCallDelay = Duration(milliseconds: 500);

@Riverpod(keepAlive: true)
class WalletSearchQueryController extends _$WalletSearchQueryController {
  @override
  String build(WalletAssetType assetType) => '';

  set query(String query) => state = query;
}

@Riverpod(keepAlive: true)
Future<List<NftData>> filteredNfts(Ref ref) async {
  final searchQuery =
      ref.watch(walletSearchQueryControllerProvider(WalletAssetType.nft)).toLowerCase();
  await ref.debounce();
  final nfts = await ref.watch(nftsDataProvider.future);
  return _filterNfts(nfts, searchQuery);
}

@Riverpod(keepAlive: true)
Future<List<CoinsGroup>> filteredCoins(Ref ref) async {
  final searchQuery =
      ref.watch(walletSearchQueryControllerProvider(WalletAssetType.coin)).toLowerCase();
  await ref.debounce();
  final coins = await ref.watch(coinsInWalletProvider.future);
  return _filterCoins(coins, searchQuery);
}

@Riverpod(keepAlive: true)
class FilteredCoinsNotifier extends _$FilteredCoinsNotifier {
  ProviderSubscription<String>? _searchQueryListener;

  @override
  Future<List<CoinsGroup>> build() async {
    _searchQueryListener = ref.listen<String>(
      walletSearchQueryControllerProvider(WalletAssetType.coin),
      (previous, next) => search(next),
    );

    ref.onDispose(() {
      _searchQueryListener?.close();
    });

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

List<NftData> _filterNfts(List<NftData> nfts, String query) {
  if (query.isEmpty) {
    return nfts;
  }

  return nfts
      .where(
        (nft) =>
            nft.collectionName.toLowerCase().contains(query) ||
            nft.description.toLowerCase().contains(query),
      )
      .toList();
}
