// SPDX-License-Identifier: ice License 1.0

part of 'wallet_views_service.r.dart';

@riverpod
WalletViewParser walletViewParser(Ref ref) {
  final parser = WalletViewParser(ref.watch(coinsRepositoryProvider));
  return parser;
}

class WalletViewParser {
  const WalletViewParser(this.coinsRepository);

  final CoinsRepository coinsRepository;

  Future<WalletViewData> parse(
    WalletView viewDTO,
    Map<String, NetworkData> networks, {
    required bool isMainWalletView,
  }) async {
    final coinGroups = <String, CoinsGroup>{};
    final symbolGroups = <String>{};

    var totalViewBalanceUSD = 0.0;

    for (final coinInWalletDTO in viewDTO.coins) {
      final coinDTO = coinInWalletDTO.coin;
      final network = networks[coinDTO.network]!;

      var coin = CoinData.fromDTO(coinDTO, network);
      if (!coin.isValid) {
        final fromDB = await coinsRepository.getCoinById(coinDTO.id);
        if (fromDB != null) coin = fromDB;
      }

      if (!coin.isValid) {
        // coin is not valid, skip it
        continue;
      }

      // Now calculate amounts and balances for valid coins only
      var coinAmount = 0.0;
      var rawCoinAmount = '0';
      var coinBalanceUSD = 0.0;

      final aggregationItem = _searchAggregationItem(
        coinInWalletDTO: coinInWalletDTO,
        aggregation: viewDTO.aggregation,
      );

      if (aggregationItem != null) {
        final asset = aggregationItem.wallets
            .firstWhereOrNull(
              (wallet) => wallet.walletId == coinInWalletDTO.walletId,
            )
            ?.asset;

        if (asset != null) {
          rawCoinAmount = asset.balance;
          coinAmount = parseCryptoAmount(asset.balance, asset.decimals);
          coinBalanceUSD = coinAmount * coinDTO.priceUSD;
        }
      }

      totalViewBalanceUSD += coinBalanceUSD;
      final symbolGroup = coinDTO.symbolGroup;
      symbolGroups.add(symbolGroup);

      final coinInWallet = CoinInWalletData(
        coin: coin,
        amount: coinAmount,
        rawAmount: rawCoinAmount,
        balanceUSD: coinBalanceUSD,
        walletId: coinInWalletDTO.walletId,
      );

      final currentGroup = coinGroups[symbolGroup] ?? CoinsGroup.fromCoin(coinInWallet.coin);
      coinGroups[symbolGroup] = currentGroup.copyWith(
        totalAmount: currentGroup.totalAmount + coinInWallet.amount,
        totalBalanceUSD: currentGroup.totalBalanceUSD + coinInWallet.balanceUSD,
        coins: [
          ...currentGroup.coins,
          coinInWallet,
        ],
      );
    }

    return WalletViewData(
      coinGroups: coinGroups.values.sorted(CoinsComparator().compareGroups),
      id: viewDTO.id,
      name: viewDTO.name,
      symbolGroups: symbolGroups,
      nfts: viewDTO.nfts?.map((nft) => nft.toNft(networks[nft.network]!)).toList() ?? [],
      createdAt: viewDTO.createdAt.microsecondsSinceEpoch,
      updatedAt: viewDTO.updatedAt.microsecondsSinceEpoch,
      usdBalance: totalViewBalanceUSD,
      isMainWalletView: isMainWalletView,
    );
  }

  WalletViewAggregationItem? _searchAggregationItem({
    required CoinInWallet coinInWalletDTO,
    required Map<String, WalletViewAggregationItem> aggregation,
  }) {
    WalletViewAggregationItem? search(Iterable<WalletViewAggregationItem> searchSample) {
      for (final aggregation in aggregation.values) {
        final associatedWallet = aggregation.wallets.firstWhereOrNull(
          (e) => e.walletId == coinInWalletDTO.walletId && e.coinId == coinInWalletDTO.coin.id,
        );
        if (associatedWallet != null && associatedWallet.network == coinInWalletDTO.coin.network) {
          return aggregation;
        }
      }
      return null;
    }

    // Return aggregation item if aggregation map contains coin symbol as a key
    // with the same wallet and coin ids as in CoinInWallet
    final symbol = coinInWalletDTO.coin.symbol;
    if (aggregation[symbol] case final WalletViewAggregationItem aggregation) {
      final result = search([aggregation]);
      if (result != null) return result;
    }

    // Attempt to find an aggregation item by indirect signs.
    // The search is performed on all aggregation items with a check
    // for matching the wallet ID, network, and coinId.
    return search(aggregation.values);
  }
}
