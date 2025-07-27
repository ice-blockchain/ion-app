// SPDX-License-Identifier: ice License 1.0

part of 'wallet_views_service.r.dart';

/// Helper class to tag different stream types for combination
class _StreamUpdate {
  const _StreamUpdate.coinTransactions(
    Map<CoinData, List<TransactionData>> data,
  )   : coinTransactions = data,
        nftTransactions = null,
        coins = null;

  const _StreamUpdate.nftTransactions(List<TransactionData> data)
      : coinTransactions = null,
        nftTransactions = data,
        coins = null;

  const _StreamUpdate.coins(List<CoinData> data)
      : coinTransactions = null,
        nftTransactions = null,
        coins = data;

  final Map<CoinData, List<TransactionData>>? coinTransactions;
  final List<TransactionData>? nftTransactions;
  final List<CoinData>? coins;
}

@riverpod
Future<WalletViewsLiveUpdater> walletViewsLiveUpdater(Ref ref) async {
  final (transactionsRepo, userWallets) = await (
    ref.watch(transactionsRepositoryProvider.future),
    ref.watch(walletsNotifierProvider.future),
  ).wait;

  return WalletViewsLiveUpdater(
    transactionsRepo,
    ref.watch(coinsRepositoryProvider),
    userWallets,
  );
}

class WalletViewsLiveUpdater {
  WalletViewsLiveUpdater(
    this._transactionsRepository,
    this._coinsRepository,
    this._userWallets,
  );

  final TransactionsRepository _transactionsRepository;
  final CoinsRepository _coinsRepository;
  final List<Wallet> _userWallets;

  /// Watches for live updates to wallet views.
  /// Returns a stream of fully updated wallet views.
  Stream<List<WalletViewData>> watchWalletViews(
    List<WalletViewData> walletViews,
  ) async* {
    if (walletViews.isEmpty) {
      Logger.error(
        'WalletViewsLiveUpdater: No wallet views to watch, returning empty stream',
      );
      return;
    }

    final coinIds = _extractCoinIds(walletViews);
    final hasNfts = _hasNfts(walletViews);

    Logger.info(
      'WalletViewsLiveUpdater: Starting to watch ${coinIds.length} coins and ${hasNfts ? 'NFTs' : 'no NFTs'} for updates',
    );

    if (coinIds.isEmpty && !hasNfts) {
      Logger.info('WalletViewsLiveUpdater: No coins or NFTs to watch, returning empty stream');
      return;
    }

    final coinTransactionsStream = _createCoinTransactionsStream(coinIds);
    final nftTransactionsStream = _createNftTransactionsStream(walletViews);
    final coinsStream = _createCoinsStream(coinIds);

    await for (final update in _combineStreams(
      coinTransactionsStream,
      nftTransactionsStream,
      coinsStream,
    )) {
      yield _applyWalletViewUpdates(walletViews, update);
    }
  }

  /// Applies filtering rules to wallet views without creating streams.
  /// Uses the same unified logic as the stream-based filtering.
  Future<List<WalletViewData>> applyFiltering(
    List<WalletViewData> walletViews,
  ) async {
    if (walletViews.isEmpty) {
      return walletViews;
    }

    final coinIds = _extractCoinIds(walletViews);
    final hasNfts = _hasNfts(walletViews);

    if (coinIds.isEmpty && !hasNfts) {
      return walletViews;
    }

    Logger.info(
      '[NFT_SYNC_FILTER_DEBUG] 🔄 Applying synchronous filtering | '
      'WalletViews: ${walletViews.length} | '
      'CoinIds: ${coinIds.length} | HasNfts: $hasNfts',
    );

    // Get current data using the same logic as streams but synchronously
    final coinTransactions = await _getCoinTransactionsData(coinIds);
    final nftTransactions = await _getNftTransactionsData(walletViews);
    final updatedCoins = await _getCoinsData(coinIds);

    Logger.info(
      '[NFT_SYNC_FILTER_DEBUG] ✅ Data retrieved | '
      'CoinTransactions: ${coinTransactions.values.fold(0, (sum, txs) => sum + txs.length)} | '
      'NftTransactions: ${nftTransactions.length} | '
      'UpdatedCoins: ${updatedCoins.length}',
    );

    // Create update object and apply filtering
    final update = WalletViewUpdate(
      coinTransactions: coinTransactions,
      nftTransactions: nftTransactions,
      updatedCoins: updatedCoins,
    );

    return _applyWalletViewUpdates(walletViews, update);
  }

  Future<Map<CoinData, List<TransactionData>>> _getCoinTransactionsData(
    Set<String> coinIds,
  ) async {
    if (coinIds.isEmpty) {
      return <CoinData, List<TransactionData>>{};
    }

    final transactions =
        await _transactionsRepository.watchBroadcastedTransfersByCoins(coinIds.toList()).first;

    // Filter out tier 2 networks
    return Map.fromEntries(
      transactions.entries.where((e) => e.key.network.tier == 1),
    );
  }

  /// Gets NFT transactions data synchronously or as stream
  Future<List<TransactionData>> _getNftTransactionsData(
    List<WalletViewData> walletViews,
  ) async {
    final nftIdentifiers = _extractNftIdentifiers(walletViews);

    if (nftIdentifiers.isEmpty) {
      return <TransactionData>[];
    }

    Logger.info(
      '[NFT_UNIFIED_DEBUG] Getting NFT transactions data | '
      'Watching ${nftIdentifiers.length} NFT identifiers | '
      'NFT_IDs: [${nftIdentifiers.map((id) => id.value).join(', ')}] | '
      'Query: type=SEND, assetType=NFT, statuses=IN_PROGRESS',
    );

    final transactions = await _transactionsRepository
        .watchTransactions(
          type: TransactionType.send,
          assetType: CryptoAssetType.nft,
          nftIdentifiers: nftIdentifiers,
          statuses: TransactionStatus.inProgressStatuses,
        )
        .first;

    // Filter out tier 2 networks for NFTs
    final tier1Transactions = transactions.where((tx) => tx.network.tier == 1).toList();

    Logger.info(
      '[NFT_UNIFIED_DEBUG] ✅ NFT Data Results | '
      'Total: ${transactions.length} transactions | '
      'Tier1: ${tier1Transactions.length} transactions | '
      'Status: All IN_PROGRESS | Type: SEND',
    );

    for (final tx in tier1Transactions) {
      final nftId = tx.cryptoAsset.when(
        coin: (_, __, ___, ____, _____) => 'N/A',
        nft: (nft) => nft.identifier.value,
        nftIdentifier: (identifier, _) => identifier.value,
      );
      Logger.info(
        '[NFT_UNIFIED_DEBUG] Data TX | '
        'Hash: ${tx.txHash} | Status: ${tx.status} | '
        'NFT_ID: $nftId | Network: ${tx.network.id} | '
        'WalletView: ${tx.walletViewId} | Sender: ${tx.senderWalletAddress}',
      );
    }

    return tier1Transactions;
  }

  /// Gets coins data synchronously or as stream
  Future<List<CoinData>> _getCoinsData(Set<String> coinIds) async {
    if (coinIds.isEmpty) {
      return <CoinData>[];
    }

    return _coinsRepository.watchCoins(coinIds).first;
  }

  /// Extracts unique coin IDs from wallet views
  Set<String> _extractCoinIds(List<WalletViewData> walletViews) {
    return walletViews
        .expand((view) => view.coinGroups)
        .expand((group) => group.coins)
        .map((coin) => coin.coin.id)
        .toSet();
  }

  /// Checks if any wallet views contain NFTs
  bool _hasNfts(List<WalletViewData> walletViews) {
    return walletViews.any((view) => view.nfts.isNotEmpty);
  }

  /// Extracts NFT identifiers from wallet views
  List<NftIdentifier> _extractNftIdentifiers(List<WalletViewData> walletViews) {
    return walletViews.expand((view) => view.nfts).map((nft) => nft.identifier).toList();
  }

  Stream<Map<CoinData, List<TransactionData>>> _createCoinTransactionsStream(Set<String> coinIds) {
    if (coinIds.isEmpty) {
      return Stream.value(<CoinData, List<TransactionData>>{});
    }

    return _transactionsRepository.watchBroadcastedTransfersByCoins(coinIds.toList()).map(
          (transactions) => Map.fromEntries(
            transactions.entries.where((e) => e.key.network.tier == 1),
          ),
        );
  }

  Stream<List<TransactionData>> _createNftTransactionsStream(
    List<WalletViewData> walletViews,
  ) {
    final nftIdentifiers = _extractNftIdentifiers(walletViews);

    if (nftIdentifiers.isEmpty) {
      return Stream.value(<TransactionData>[]);
    }

    return _transactionsRepository
        .watchTransactions(
          type: TransactionType.send,
          assetType: CryptoAssetType.nft,
          nftIdentifiers: nftIdentifiers,
          statuses: TransactionStatus.inProgressStatuses,
        )
        .map((transactions) => transactions.where((tx) => tx.network.tier == 1).toList());
  }

  Stream<List<CoinData>> _createCoinsStream(Set<String> coinIds) {
    if (coinIds.isEmpty) {
      return Stream.value(<CoinData>[]);
    }
    return _coinsRepository.watchCoins(coinIds);
  }

  /// Combines all streams into a single WalletViewUpdate stream
  Stream<WalletViewUpdate> _combineStreams(
    Stream<Map<CoinData, List<TransactionData>>> coinTransactionsStream,
    Stream<List<TransactionData>> nftTransactionsStream,
    Stream<List<CoinData>> coinsStream,
  ) async* {
    // Convert each stream to a tagged wrapper for easier combination
    final taggedCoinTransactions = coinTransactionsStream.map(_StreamUpdate.coinTransactions);
    final taggedNftTransactions = nftTransactionsStream.map(_StreamUpdate.nftTransactions);
    final taggedCoins = coinsStream.map(_StreamUpdate.coins);

    await for (final combinedList in taggedCoinTransactions.combineLatestAll([
      taggedNftTransactions,
      taggedCoins,
    ]).distinct((a, b) {
      // Extract data for comparison
      final coinTransactionsA = a[0].coinTransactions!;
      final nftTransactionsA = a[1].nftTransactions!;
      final coinsA = a[2].coins!;

      final coinTransactionsB = b[0].coinTransactions!;
      final nftTransactionsB = b[1].nftTransactions!;
      final coinsB = b[2].coins!;

      return const MapEquality<CoinData, List<TransactionData>>()
              .equals(coinTransactionsA, coinTransactionsB) &&
          const UnorderedIterableEquality<TransactionData>()
              .equals(nftTransactionsA, nftTransactionsB) &&
          const UnorderedIterableEquality<CoinData>().equals(coinsA, coinsB);
    })) {
      // Extract the actual data from the tagged wrappers
      final coinTransactions = combinedList[0].coinTransactions!;
      final nftTransactions = combinedList[1].nftTransactions!;
      final updatedCoins = combinedList[2].coins!;

      Logger.info(
        'WalletViewsLiveUpdater: Emitting update - ${updatedCoins.length} coins, ${coinTransactions.length} coin transactions, ${nftTransactions.length} NFT transactions',
      );

      yield WalletViewUpdate(
        updatedCoins: updatedCoins,
        coinTransactions: coinTransactions,
        nftTransactions: nftTransactions,
      );
    }
  }

  /// Applies wallet view updates to the current wallet views
  List<WalletViewData> _applyWalletViewUpdates(
    List<WalletViewData> views,
    WalletViewUpdate update,
  ) {
    return views.map((walletView) {
      final updatedGroups = walletView.coinGroups.map((group) {
        var totalGroupAmount = 0.0;
        var totalGroupBalanceUSD = 0.0;

        final updatedCoinsInGroup = group.coins.map((coinInWallet) {
          var modifiedCoin = _applyUpdatedCoinPrice(
            coinInWallet: coinInWallet,
            updatedCoins: update.updatedCoins,
          );

          modifiedCoin = _applyExecutingTransactions(
            coinInWallet: modifiedCoin,
            transactions: update.coinTransactions,
            walletViewId: walletView.id,
          );

          totalGroupAmount += modifiedCoin.amount;
          totalGroupBalanceUSD += modifiedCoin.balanceUSD;

          return modifiedCoin;
        }).toList();

        return group.copyWith(
          coins: updatedCoinsInGroup,
          totalAmount: totalGroupAmount,
          totalBalanceUSD: totalGroupBalanceUSD,
        );
      }).toList();

      // Apply NFT filtering for broadcasted transactions
      final filteredNfts = _applyExecutingNftTransactions(
        nfts: walletView.nfts,
        transactions: update.nftTransactions,
        walletViewId: walletView.id,
      );

      return walletView.copyWith(
        coinGroups: updatedGroups,
        nfts: filteredNfts,
        usdBalance: updatedGroups.fold(0, (sum, group) => sum + group.totalBalanceUSD),
      );
    }).toList();
  }

  /// Updates coin usd price
  CoinInWalletData _applyUpdatedCoinPrice({
    required Iterable<CoinData> updatedCoins,
    required CoinInWalletData coinInWallet,
  }) {
    if (updatedCoins.isNotEmpty) {
      final updatedCoin = updatedCoins.firstWhereOrNull(
        (coin) => coin.id == coinInWallet.coin.id,
      );

      if (updatedCoin != null) {
        final balanceUSD = coinInWallet.amount * updatedCoin.priceUSD;
        return coinInWallet.copyWith(
          coin: updatedCoin,
          balanceUSD: balanceUSD,
        );
      }
    }

    return coinInWallet;
  }

  /// Subtracts sent coins from the existing number of coins.
  CoinInWalletData _applyExecutingTransactions({
    required String walletViewId,
    required CoinInWalletData coinInWallet,
    required Map<CoinData, List<TransactionData>> transactions,
  }) {
    var updatedCoin = coinInWallet;

    if (transactions.isNotEmpty) {
      final key = transactions.keys.firstWhereOrNull(
        (key) => key.id == coinInWallet.coin.id,
      );
      final coinTransactions = transactions[key] ?? [];
      final wallet = _userWallets.firstWhereOrNull(
        (w) => w.id == coinInWallet.walletId,
      );

      var adjustedRawAmount = BigInt.parse(coinInWallet.rawAmount);

      if (coinTransactions.isNotEmpty) {
        Logger.info(
          'Apply broadcasted transactions(${transactions.length}) '
          'for ${coinInWallet.coin.abbreviation}(${coinInWallet.coin.name}). '
          'Network: ${coinInWallet.coin.network.id}. Initial balance: ${coinInWallet.amount}.',
        );
      }

      var balanceHackApplied = false;
      for (final transaction in coinTransactions) {
        final isTransactionRelatedToCoin = transaction.senderWalletAddress == wallet?.address;
        final isTransactionRelatedToWalletView = transaction.walletViewId == walletViewId;
        final transactionCoin = transaction.cryptoAsset;

        if (isTransactionRelatedToCoin &&
            transactionCoin is CoinTransactionAsset &&
            isTransactionRelatedToWalletView) {
          adjustedRawAmount -= BigInt.parse(transactionCoin.rawAmount);

          balanceHackApplied = true;
          Logger.info(
            'Reduce coin amount according to the next transactions: '
            'amount: ${transactionCoin.amount} txHash: ${transaction.txHash}, '
            'network: ${transaction.network.id}, coin: ${transactionCoin.coin}',
          );
        }
      }

      final adjustedAmount = parseCryptoAmount(
        (adjustedRawAmount.isNegative ? 0 : adjustedRawAmount).toString(),
        coinInWallet.coin.decimals,
      );
      final adjustedBalanceUSD = adjustedAmount * coinInWallet.coin.priceUSD;

      if (adjustedAmount > 0 && balanceHackApplied) {
        Logger.info(
          'The reduction is complete. Adjusted amount: $adjustedAmount',
        );
      }

      updatedCoin = coinInWallet.copyWith(
        amount: adjustedAmount,
        balanceUSD: adjustedBalanceUSD,
        rawAmount: adjustedRawAmount.toString(),
      );
    }

    return updatedCoin;
  }

  /// Filters out NFTs that have been sent and are still in-progress (pending, executing, broadcasted).
  List<NftData> _applyExecutingNftTransactions({
    required String walletViewId,
    required List<NftData> nfts,
    required List<TransactionData> transactions,
  }) {
    if (transactions.isEmpty) {
      Logger.info(
        '[NFT_DEBUG] FILTER: No NFT transactions to filter for wallet view $walletViewId, returning ${nfts.length} NFTs unchanged',
      );
      return nfts;
    }

    Logger.info(
      '[NFT_FILTER_DEBUG] 🔍 Starting NFT filtering | '
      'WalletView: $walletViewId | '
      'NFTs to filter: ${nfts.length} | '
      'Transactions to check: ${transactions.length} | '
      'User wallets: ${_userWallets.length}',
    );

    // Log the NFTs in the wallet view
    Logger.info('[NFT_FILTER_DEBUG] 📋 Available NFTs in wallet view:');
    for (final nft in nfts) {
      Logger.info(
        '[NFT_FILTER_DEBUG] NFT | Name: ${nft.name} | '
        'ID: ${nft.identifier.value} | '
        'Contract: ${nft.contract} | TokenId: ${nft.tokenId} | Symbol: ${nft.symbol}',
      );
    }

    // Log the transactions we're filtering against
    Logger.info('[NFT_FILTER_DEBUG] 📝 In-progress send transactions to check:');
    for (final tx in transactions) {
      final nftId = tx.cryptoAsset.when(
        coin: (_, __, ___, ____, _____) => 'N/A',
        nft: (nft) => nft.identifier.value,
        nftIdentifier: (identifier, _) => identifier.value,
      );
      Logger.info(
        '[NFT_FILTER_DEBUG] TX | Hash: ${tx.txHash} | '
        'Status: ${tx.status} | NFT_ID: $nftId | '
        'WalletView: ${tx.walletViewId} | Sender: ${tx.senderWalletAddress}',
      );
    }

    final filteredNfts = <NftData>[];
    var nftsFiltered = 0;

    for (final nft in nfts) {
      var shouldFilterOut = false;

      // Look for matching NFT transactions
      for (final transaction in transactions) {
        final wallet = _userWallets.firstWhereOrNull(
          (w) => w.address == transaction.senderWalletAddress,
        );

        final isTransactionRelatedToNft = transaction.senderWalletAddress == wallet?.address;
        final isTransactionRelatedToWalletView = transaction.walletViewId == walletViewId;
        final transactionNft = transaction.cryptoAsset;

        // Check if this is an NFT transaction (either full or minimized)
        final isNftTransaction = transactionNft is NftTransactionAsset ||
            transactionNft is NftIdentifierTransactionAsset;

        // Get the NFT identifier from either variant
        final transactionNftIdentifier = switch (transactionNft) {
          NftTransactionAsset(nft: final nft) => nft.identifier,
          NftIdentifierTransactionAsset(nftIdentifier: final identifier) => identifier,
          _ => null,
        };

        Logger.info(
          '[NFT_FILTER_DEBUG] 🔍 Checking NFT vs Transaction | '
          'NFT_ID: ${nft.identifier.value} | TX: ${transaction.txHash} | '
          'TxNftId: $transactionNftIdentifier | IDMatch: ${transactionNftIdentifier == nft.identifier} | '
          'RelatedToNft: $isTransactionRelatedToNft | IsNftTx: $isNftTransaction | '
          'RelatedToWalletView: $isTransactionRelatedToWalletView | '
          'TxSender: ${transaction.senderWalletAddress} | WalletAddr: ${wallet?.address}',
        );

        if (isTransactionRelatedToNft &&
            isNftTransaction &&
            isTransactionRelatedToWalletView &&
            transactionNftIdentifier != null &&
            transactionNftIdentifier == nft.identifier) {
          Logger.info(
            '[NFT_FILTER_DEBUG] ❌ FILTERING OUT NFT | '
            'Name: ${nft.name} | NFT_ID: ${nft.identifier.value} | '
            'Reason: ${transaction.status} transaction | '
            'TX: ${transaction.txHash} | Network: ${transaction.network.id}',
          );
          shouldFilterOut = true;
          nftsFiltered++;
          break;
        }
      }

      if (!shouldFilterOut) {
        filteredNfts.add(nft);
      }
    }

    Logger.info(
      '[NFT_FILTER_DEBUG] ✅ FILTERING COMPLETE | '
      'WalletView: $walletViewId | '
      'Filtered out: $nftsFiltered NFTs | '
      'Remaining: ${filteredNfts.length} NFTs | '
      'Original: ${nfts.length} NFTs',
    );

    // Log remaining NFTs
    if (filteredNfts.isNotEmpty) {
      Logger.info('[NFT_FILTER_DEBUG] 📋 Remaining NFTs after filtering:');
      for (final nft in filteredNfts) {
        Logger.info(
          '[NFT_FILTER_DEBUG] Remaining | Name: ${nft.name} | ID: ${nft.identifier.value} | Contract: ${nft.contract} | TokenId: ${nft.tokenId} | Symbol: ${nft.symbol}',
        );
      }
    } else {
      Logger.info('[NFT_FILTER_DEBUG] 🚫 No NFTs remaining after filtering');
    }

    return filteredNfts;
  }
}
