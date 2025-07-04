// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:collection/collection.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/core/providers/main_wallet_provider.r.dart';
import 'package:ion/app/features/core/providers/wallets_provider.r.dart';
import 'package:ion/app/features/wallets/data/mappers/nft_mapper.dart';
import 'package:ion/app/features/wallets/data/repository/coins_repository.r.dart';
import 'package:ion/app/features/wallets/data/repository/networks_repository.r.dart';
import 'package:ion/app/features/wallets/data/repository/transactions_repository.m.dart';
import 'package:ion/app/features/wallets/domain/coins/coins_comparator.dart';
import 'package:ion/app/features/wallets/domain/wallet_views/sync_wallet_views_coins_service.r.dart';
import 'package:ion/app/features/wallets/model/coin_data.f.dart';
import 'package:ion/app/features/wallets/model/coin_in_wallet_data.f.dart';
import 'package:ion/app/features/wallets/model/coins_group.f.dart';
import 'package:ion/app/features/wallets/model/network_data.f.dart';
import 'package:ion/app/features/wallets/model/transaction_crypto_asset.f.dart';
import 'package:ion/app/features/wallets/model/transaction_data.f.dart';
import 'package:ion/app/features/wallets/model/wallet_view_data.f.dart';
import 'package:ion/app/features/wallets/utils/crypto_amount_parser.dart';
import 'package:ion/app/services/ion_identity/ion_identity_client_provider.r.dart';
import 'package:ion/app/services/logger/logger.dart';
import 'package:ion_identity_client/ion_identity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:stream_transform/stream_transform.dart';

part 'create_update_wallet_view_request_builder.dart';
part 'wallet_views_service.r.g.dart';

@riverpod
Future<WalletViewsService> walletViewsService(Ref ref) async {
  final (
    identity,
    wallets,
    mainWallet,
    transactionsRepo,
    syncService,
  ) = await (
    ref.watch(ionIdentityClientProvider.future),
    ref.watch(walletsNotifierProvider.future),
    ref.watch(mainWalletProvider.future),
    ref.watch(transactionsRepositoryProvider.future),
    ref.watch(syncWalletViewCoinsServiceProvider.future),
  ).wait;

  final service = WalletViewsService(
    identity,
    wallets,
    mainWallet,
    ref.watch(coinsRepositoryProvider),
    ref.watch(networksRepositoryProvider),
    transactionsRepo,
    syncService,
  );

  ref.onDispose(service.dispose);

  return service;
}

class WalletViewsService {
  WalletViewsService(
    this._identity,
    this._userWallets,
    this._mainUserWallet,
    this._coinsRepository,
    this._networksRepository,
    this._transactionsRepository,
    this._syncWalletViewCoinsService,
  );

  final List<Wallet> _userWallets;
  final Wallet? _mainUserWallet;
  final IONIdentityClient _identity;
  final CoinsRepository _coinsRepository;
  final NetworksRepository _networksRepository;
  final TransactionsRepository _transactionsRepository;
  final SyncWalletViewCoinsService _syncWalletViewCoinsService;

  final StreamController<List<WalletViewData>> _walletViewsController =
      StreamController.broadcast();

  Stream<List<WalletViewData>> get walletViews => _walletViewsController.stream;
  List<WalletViewData> _originWalletViews = [];
  List<WalletViewData> _modifiedWalletViews = [];

  List<WalletViewData> get lastEmitted => _modifiedWalletViews;

  StreamSubscription<(List<CoinData>, Map<CoinData, List<TransactionData>>)>? _updatesSubscription;

  Future<List<WalletViewData>> fetch() async {
    final shortViews = await _identity.wallets.getWalletViews();

    final viewsDetailsDTO = await Future.wait(
      shortViews.map((e) => _identity.wallets.getWalletView(e.id)),
    );
    final networks = await _networksRepository.getAllAsMap();
    final mainWalletViewId = viewsDetailsDTO.isEmpty
        ? '' // if there no wallet views, we haven't the main one
        : viewsDetailsDTO.reduce((a, b) => a.createdAt.isBefore(b.createdAt) ? a : b).id;

    _originWalletViews = viewsDetailsDTO
        .map(
          (viewDTO) => _parseWalletView(
            viewDTO,
            networks,
            isMainWalletView: viewDTO.id == mainWalletViewId,
          ),
        )
        .toList();
    _updateEmittedWalletViews(walletViews: _originWalletViews);

    return _originWalletViews;
  }

  void _updateEmittedWalletViews({
    List<WalletViewData>? walletViews,
    bool refreshSubscriptions = true,
    bool updatePeriodicCoinsSync = true,
  }) {
    if (updatePeriodicCoinsSync) {
      final coins = _originWalletViews.expand((wv) => wv.coins).map((c) => c.coin).toList();
      _syncWalletViewCoinsService.start(coins);
    }

    if (walletViews != null) {
      _modifiedWalletViews = walletViews;
    }

    _walletViewsController.add(_modifiedWalletViews);

    if (refreshSubscriptions) _refreshUpdateSubscription();
  }

  void _refreshUpdateSubscription() {
    if (_originWalletViews.isEmpty) return;

    final coinIds = _originWalletViews
        .expand((view) => view.coinGroups)
        .expand((group) => group.coins)
        .map((coin) => coin.coin.id)
        .toSet();

    if (coinIds.isEmpty) return;

    _updatesSubscription?.cancel();
    _updatesSubscription = _transactionsRepository
        .watchBroadcastedTransfersByCoins(coinIds.toList())
        .map((transactions) {
          // Filter out tier 2 networks, since we don't need to apply balance hack for them.
          // It will be applied on the ion side automatically.

          return Map.fromEntries(
            transactions.entries.where(
              (e) => e.key.network.tier == 1,
            ),
          );
        })
        .combineLatest(
          _coinsRepository.watchCoins(coinIds),
          (Map<CoinData, List<TransactionData>> transactions, List<CoinData> coins) =>
              (coins, transactions),
        )
        .distinct((a, b) {
          final (coinsA, transactionsA) = a;
          final (coinsB, transactionsB) = b;

          return const UnorderedIterableEquality<CoinData>().equals(coinsA, coinsB) &&
              const MapEquality<CoinData, List<TransactionData>>()
                  .equals(transactionsA, transactionsB);
        })
        .listen((combined) {
          final (updatedCoins, transactions) = combined;

          if (_originWalletViews.isEmpty) return;

          final updatedViews = _updateWalletViews(
            _originWalletViews,
            updatedCoins: updatedCoins,
            transactions: transactions,
          );

          _updateEmittedWalletViews(
            walletViews: updatedViews,
            refreshSubscriptions: false,
            updatePeriodicCoinsSync: false,
          );
        });
  }

  List<WalletViewData> _updateWalletViews(
    List<WalletViewData> views, {
    required Iterable<CoinData> updatedCoins,
    required Map<CoinData, List<TransactionData>> transactions,
  }) {
    return views.map((walletView) {
      final updatedGroups = walletView.coinGroups.map((group) {
        var totalGroupAmount = 0.0;
        var totalGroupBalanceUSD = 0.0;

        final updatedCoinsInGroup = group.coins.map((coinInWallet) {
          var modifiedCoin = _applyUpdatedCoinPrice(
            coinInWallet: coinInWallet,
            updatedCoins: updatedCoins,
          );

          modifiedCoin = _applyExecutingTransactions(
            coinInWallet: modifiedCoin,
            transactions: transactions,
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

      return walletView.copyWith(
        coinGroups: updatedGroups,
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

  Future<WalletViewData> create(String name) async {
    final request = _CreateUpdateRequestBuilder().build(name: name);
    final networks = await _networksRepository.getAllAsMap();
    final newWalletView = await _identity.wallets.createWalletView(request).then(
          (viewDTO) => _parseWalletView(viewDTO, networks, isMainWalletView: false),
        );

    _originWalletViews = [..._originWalletViews, newWalletView];
    _updateEmittedWalletViews(walletViews: _originWalletViews);

    return newWalletView;
  }

  Future<WalletViewData> update({
    required WalletViewData walletView,
    String? updatedName,
    List<CoinData>? updatedCoinsList,
  }) async {
    final networks = await _networksRepository.getAllAsMap();
    final request = _CreateUpdateRequestBuilder().build(
      name: updatedName,
      walletView: walletView,
      coinsList: updatedCoinsList,
      userWallets: _userWallets,
      mainUserWallet: _mainUserWallet,
    );

    final updatedWalletView = await _identity.wallets.updateWalletView(walletView.id, request).then(
          (viewDTO) => _parseWalletView(
            viewDTO,
            networks,
            isMainWalletView: walletView.isMainWalletView,
          ),
        );

    final index = _originWalletViews.indexWhere((w) => w.id == walletView.id);

    if (index != -1) {
      _originWalletViews[index] = updatedWalletView;
    } else {
      _originWalletViews.add(updatedWalletView);
    }

    _updateEmittedWalletViews(walletViews: _originWalletViews);

    return updatedWalletView;
  }

  Future<void> delete({required String walletViewId}) async {
    await _identity.wallets.deleteWalletView(walletViewId);

    unawaited(
      _transactionsRepository.remove(
        walletViewIds: [walletViewId],
      ),
    );

    _originWalletViews = _originWalletViews.where((view) => view.id != walletViewId).toList();

    _updateEmittedWalletViews(walletViews: _originWalletViews);
  }

  WalletViewData _parseWalletView(
    WalletView viewDTO,
    Map<String, NetworkData> networks, {
    required bool isMainWalletView,
  }) {
    final coinGroups = <String, CoinsGroup>{};
    final symbolGroups = <String>{};

    var totalViewBalanceUSD = 0.0;

    for (final coinInWalletDTO in viewDTO.coins) {
      final coinDTO = coinInWalletDTO.coin;
      final network = networks[coinDTO.network];
      if (network == null) {
        Logger.log('Network $network not found not');
        continue;
      }

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
        amount: coinAmount,
        rawAmount: rawCoinAmount,
        balanceUSD: coinBalanceUSD,
        walletId: coinInWalletDTO.walletId,
        coin: CoinData.fromDTO(coinDTO, network),
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

  void dispose() {
    _walletViewsController.close();
    _updatesSubscription?.cancel();
  }
}
