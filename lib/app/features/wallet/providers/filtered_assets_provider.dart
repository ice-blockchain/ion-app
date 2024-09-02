import 'package:ice/app/extensions/riverpod.dart';
import 'package:ice/app/features/wallet/model/coin_data.dart';
import 'package:ice/app/features/wallet/model/nft_data.dart';
import 'package:ice/app/features/wallet/model/wallet_data_with_loading_state.dart';
import 'package:ice/app/features/wallet/providers/coins_provider.dart';
import 'package:ice/app/features/wallet/providers/nfts_provider.dart';
import 'package:ice/app/features/wallet/views/pages/wallet_page/providers/search_query_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'filtered_assets_provider.g.dart';

const debounceDuration = Duration(milliseconds: 300);
const apiCallDelay = Duration(milliseconds: 500);

@Riverpod(keepAlive: true)
Future<List<CoinData>> filteredCoins(FilteredCoinsRef ref) async {
  final searchQuery =
      ref.watch(walletSearchQueryControllerProvider(WalletAssetType.coin)).toLowerCase();
  await ref.debounce(debounceDuration);
  await Future<void>.delayed(apiCallDelay);
  final coins = ref.watch(coinsDataProvider);
  return _filterCoins(coins, searchQuery);
}

@Riverpod(keepAlive: true)
Future<List<NftData>> filteredNfts(FilteredNftsRef ref) async {
  final searchQuery =
      ref.watch(walletSearchQueryControllerProvider(WalletAssetType.nft)).toLowerCase();
  await ref.debounce(debounceDuration);
  await Future<void>.delayed(apiCallDelay);
  final nfts = ref.watch(nftsDataProvider);
  return _filterNfts(nfts, searchQuery);
}

List<CoinData> _filterCoins(List<CoinData> coins, String query) {
  if (query.isEmpty) {
    return coins;
  }
  return coins
      .where((coin) =>
          coin.name.toLowerCase().contains(query) ||
          coin.abbreviation.toLowerCase().contains(query))
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
