// SPDX-License-Identifier: ice License 1.0

import 'package:collection/collection.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/core/providers/wallets_provider.r.dart';
import 'package:ion/app/features/wallets/data/repository/coins_repository.r.dart';
import 'package:ion/app/features/wallets/data/repository/transactions_repository.m.dart';
import 'package:ion/app/features/wallets/model/coin_data.f.dart';
import 'package:ion/app/features/wallets/model/coin_in_wallet_data.f.dart';
import 'package:ion/app/features/wallets/model/crypto_asset_type.dart';
import 'package:ion/app/features/wallets/model/nft_data.f.dart';
import 'package:ion/app/features/wallets/model/transaction_crypto_asset.f.dart';
import 'package:ion/app/features/wallets/model/transaction_data.f.dart';
import 'package:ion/app/features/wallets/model/transaction_status.f.dart';
import 'package:ion/app/features/wallets/model/transaction_type.dart';
import 'package:ion/app/features/wallets/model/wallet_view_data.f.dart';
import 'package:ion/app/features/wallets/model/wallet_view_update.f.dart';
import 'package:ion/app/features/wallets/utils/crypto_amount_parser.dart';
import 'package:ion/app/services/logger/logger.dart';
import 'package:ion_identity_client/ion_identity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:stream_transform/stream_transform.dart';

part 'wallet_views_live_updater.r.g.dart';

/// Helper class to tag different stream types for combination
class _StreamUpdate {
  const _StreamUpdate.coinTransactions(Map<CoinData, List<TransactionData>> data)
      : coinTransactions = data,
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

  /// Watches for live updates to wallet views and applies them automatically.
  /// Returns a stream of fully updated wallet views.
  Stream<List<WalletViewData>> watchWalletViews(List<WalletViewData> walletViews) async* {
    if (walletViews.isEmpty) {
      Logger.info('WalletViewsLiveUpdater: No wallet views to watch, returning empty stream');
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

    // Create individual streams
    final coinTransactionsStream = _createCoinTransactionsStream(coinIds);
    final nftTransactionsStream = _createNftTransactionsStream(hasNfts);
    final coinsStream = _createCoinsStream(coinIds);

    // Combine all streams into update objects and apply them to wallet views
    await for (final update in _combineStreams(
      coinTransactionsStream,
      nftTransactionsStream,
      coinsStream,
    )) {
      final updatedWalletViews = _applyWalletViewUpdates(walletViews, update);
      yield updatedWalletViews;
    }
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

  /// Creates stream for coin transactions (broadcasted transfers)
  Stream<Map<CoinData, List<TransactionData>>> _createCoinTransactionsStream(
    Set<String> coinIds,
  ) {
    if (coinIds.isEmpty) {
      return Stream.value(<CoinData, List<TransactionData>>{});
    }

    return _transactionsRepository
        .watchBroadcastedTransfersByCoins(coinIds.toList())
        .map((transactions) {
      // Filter out tier 2 networks
      return Map.fromEntries(
        transactions.entries.where((e) => e.key.network.tier == 1),
      );
    });
  }

  /// Creates stream for NFT transactions (broadcasted transfers)
  Stream<List<TransactionData>> _createNftTransactionsStream(bool hasNfts) {
    if (!hasNfts) {
      return Stream.value(<TransactionData>[]);
    }

    return _transactionsRepository
        .watchTransactions(
      type: TransactionType.send,
      assetType: CryptoAssetType.nft,
      statuses: TransactionStatus.inProgressStatuses,
    )
        .map((transactions) {
      // Filter out tier 2 networks for NFTs
      Logger.info(
          'WalletViewsLiveUpdater: Found ${transactions.length} NFT transactions with in-progress status');
      return transactions.where((tx) => tx.network.tier == 1).toList();
    });
  }

  /// Creates stream for coin data updates (price changes)
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
        Logger.info('The reduction is complete. Adjusted amount: $adjustedAmount');
      }

      updatedCoin = coinInWallet.copyWith(
        amount: adjustedAmount,
        balanceUSD: adjustedBalanceUSD,
        rawAmount: adjustedRawAmount.toString(),
      );
    }

    return updatedCoin;
  }

  /// Filters out NFTs that have been sent but are still in broadcasted status.
  List<NftData> _applyExecutingNftTransactions({
    required String walletViewId,
    required List<NftData> nfts,
    required List<TransactionData> transactions,
  }) {
    if (transactions.isEmpty) {
      Logger.info(
        'WalletViewsLiveUpdater: No NFT transactions to filter for wallet view $walletViewId',
      );
      return nfts;
    }

    Logger.info(
      'WalletViewsLiveUpdater: Filtering ${nfts.length} NFTs against ${transactions.length} NFT transactions for wallet view $walletViewId',
    );

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

        if (isTransactionRelatedToNft &&
            transactionNft is NftTransactionAsset &&
            isTransactionRelatedToWalletView &&
            transactionNft.nft.identifier == nft.identifier) {
          Logger.info(
            'WalletViewsLiveUpdater: Filtering out NFT ${nft.name} (${nft.contract}:${nft.tokenId}) '
            'due to broadcasted transaction ${transaction.txHash} on network ${transaction.network.id}',
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
      'WalletViewsLiveUpdater: Filtered out $nftsFiltered NFTs, ${filteredNfts.length} NFTs remaining',
    );
    return filteredNfts;
  }
}
