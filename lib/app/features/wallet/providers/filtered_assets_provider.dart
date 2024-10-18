// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/extensions/riverpod.dart';
import 'package:ion/app/features/wallet/model/coin_data.dart';
import 'package:ion/app/features/wallet/model/nft_data.dart';
import 'package:ion/app/features/wallet/model/wallet_data_with_loading_state.dart';
import 'package:ion/app/features/wallet/providers/coins_provider.dart';
import 'package:ion/app/features/wallet/providers/nfts_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'filtered_assets_provider.g.dart';

const apiCallDelay = Duration(milliseconds: 500);

@Riverpod(keepAlive: true)
class WalletSearchQueryController extends _$WalletSearchQueryController {
  @override
  String build(WalletAssetType assetType) => '';

  set query(String query) => state = query;
}

@Riverpod(keepAlive: true)
Future<List<CoinData>> filteredCoins(FilteredCoinsRef ref) async {
  final searchQuery =
      ref.watch(walletSearchQueryControllerProvider(WalletAssetType.coin)).toLowerCase();
  await ref.debounce();
  await Future<void>.delayed(apiCallDelay);
  final coins = ref.watch(coinsDataProvider);
  return _filterCoins(coins, searchQuery);
}

@Riverpod(keepAlive: true)
Future<List<NftData>> filteredNfts(FilteredNftsRef ref) async {
  final searchQuery =
      ref.watch(walletSearchQueryControllerProvider(WalletAssetType.nft)).toLowerCase();
  await ref.debounce();
  await Future<void>.delayed(apiCallDelay);
  final nfts = ref.watch(nftsDataProvider);
  return _filterNfts(nfts, searchQuery);
}

List<CoinData> _filterCoins(List<CoinData> coins, String query) {
  if (query.isEmpty) {
    return coins;
  }
  return coins
      .where(
        (coin) =>
            coin.name.toLowerCase().contains(query) ||
            coin.abbreviation.toLowerCase().contains(query),
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
