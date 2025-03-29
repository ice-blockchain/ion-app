// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:collection/collection.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/core/providers/wallets_provider.c.dart';
import 'package:ion/app/features/wallets/data/mappers/nft_mapper.dart';
import 'package:ion/app/features/wallets/data/repository/coins_repository.c.dart';
import 'package:ion/app/features/wallets/data/repository/networks_repository.c.dart';
import 'package:ion/app/features/wallets/data/repository/transactions_repository.c.dart';
import 'package:ion/app/features/wallets/domain/coins/coins_comparator.dart';
import 'package:ion/app/features/wallets/model/coin_data.c.dart';
import 'package:ion/app/features/wallets/model/coin_in_wallet_data.c.dart';
import 'package:ion/app/features/wallets/model/coins_group.c.dart';
import 'package:ion/app/features/wallets/model/network_data.c.dart';
import 'package:ion/app/features/wallets/model/transaction_crypto_asset.c.dart';
import 'package:ion/app/features/wallets/model/transaction_data.c.dart';
import 'package:ion/app/features/wallets/model/wallet_view_data.c.dart';
import 'package:ion/app/features/wallets/utils/crypto_amount_parser.dart';
import 'package:ion/app/services/ion_identity/ion_identity_client_provider.c.dart';
import 'package:ion_identity_client/ion_identity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'create_update_wallet_view_request_builder.dart';
part 'wallet_views_service.c.g.dart';

@riverpod
Future<WalletViewsService> walletViewsService(Ref ref) async {
  final service = WalletViewsService(
    await ref.watch(ionIdentityClientProvider.future),
    await ref.watch(walletsNotifierProvider.future),
    ref.watch(coinsRepositoryProvider),
    ref.watch(networksRepositoryProvider),
    await ref.watch(transactionsRepositoryProvider.future),
  );

  ref.onDispose(service.dispose);

  return service;
}

// TODO: Combine two subscriptions into one and make an analogue of combineLatest,
// so both streams will be listened and the latest emits will be merged into one
class WalletViewsService {
  WalletViewsService(
    this._identity,
    this._userWallets,
    this._coinsRepository,
    this._networksRepository,
    this._transactionsRepository,
  );

  final List<Wallet> _userWallets;
  final IONIdentityClient _identity;
  final CoinsRepository _coinsRepository;
  final NetworksRepository _networksRepository;
  final TransactionsRepository _transactionsRepository;

  final StreamController<List<WalletViewData>> _walletViewsController =
      StreamController.broadcast();
  Stream<List<WalletViewData>> get walletViews => _walletViewsController.stream;
  List<WalletViewData> _originWalletViews = [];
  List<WalletViewData> _modifiedWalletViews = [];
  List<WalletViewData> get lastEmitted => _modifiedWalletViews;

  StreamSubscription<Iterable<CoinData>>? _pricesSubscription;
  StreamSubscription<Map<CoinData, List<TransactionData>>>? _transactionsSubscription;

  Future<List<WalletViewData>> fetch() async {
    final shortViews = await _identity.wallets.getWalletViews();

    final viewsDetailsDTO = await Future.wait(
      shortViews.map((e) => _identity.wallets.getWalletView(e.id)),
    );
    final networks = await _networksRepository.getAllAsMap();
    final mainWalletViewId =
        viewsDetailsDTO.reduce((a, b) => a.createdAt.isBefore(b.createdAt) ? a : b).id;

    _originWalletViews = viewsDetailsDTO
        .map(
          (viewDTO) => _parseWalletView(
            viewDTO,
            networks,
            isMainWalletView: viewDTO.id == mainWalletViewId,
          ),
        )
        .toList();
    _emitModifiedWalletViews(walletViews: _originWalletViews);

    return _originWalletViews;
  }

  void _emitModifiedWalletViews({
    List<WalletViewData>? walletViews,
    bool refreshSubscriptions = true,
  }) {
    if (walletViews != null) {
      _modifiedWalletViews = walletViews;
    }

    _walletViewsController.add(_modifiedWalletViews);

    if (refreshSubscriptions) _refreshSubscriptions();
  }

  void _refreshSubscriptions() {
    if (_modifiedWalletViews.isNotEmpty) {
      _listenForPricesUpdate();
      _listenForTransactions();
    }
  }

  Future<void> _listenForTransactions() async {
    final coinIds =
        _originWalletViews.expand((view) => view.coins).map((coin) => coin.coin.id).toSet();

    if (coinIds.isEmpty) return;

    if (_transactionsSubscription != null) await _transactionsSubscription?.cancel();

    _transactionsSubscription = _transactionsRepository
        .watchBroadcastedTransfersByCoins(coinIds.toList())
        .distinct()
        .listen((transactions) {
      if (transactions.isEmpty) return;

      final updatedViews = <WalletViewData>[];

      for (final walletView in _originWalletViews) {
        final updatedCoinGroups = <CoinsGroup>[];

        for (final coinsGroup in walletView.coinGroups) {
          var totalGroupAmount = 0.0;
          var totalGroupBalanceUSD = 0.0;
          final updatedCoinsInWallet = <CoinInWalletData>[];

          for (final coinInWallet in coinsGroup.coins) {
            var modifiedCoin = coinInWallet.copyWith();
            final key = transactions.keys.firstWhereOrNull((key) => key.id == coinInWallet.coin.id);
            final coinRelatedTransactions = transactions[key] ?? [];
            final wallet = _userWallets.firstWhereOrNull((w) => w.id == modifiedCoin.walletId);

            for (final transaction in coinRelatedTransactions) {
              // Check if transaction related to the coin wallet and we should modify amount/balance of it
              final isTransactionRelatedToCoin = transaction.senderWalletAddress == wallet?.address;
              final transactionCoin = transaction.cryptoAsset;

              if (isTransactionRelatedToCoin && transactionCoin is CoinTransactionAsset) {
                final adjustedRawAmount =
                    (BigInt.parse(modifiedCoin.rawAmount) - BigInt.parse(transactionCoin.rawAmount))
                        .toString();
                final adjustedAmount = parseCryptoAmount(
                  adjustedRawAmount,
                  modifiedCoin.coin.decimals,
                );
                final adjustedBalanceUSD = adjustedAmount * modifiedCoin.coin.priceUSD;

                modifiedCoin = modifiedCoin.copyWith(
                  amount: adjustedAmount,
                  balanceUSD: adjustedBalanceUSD,
                  rawAmount: adjustedRawAmount,
                );
              }
            }

            totalGroupAmount += modifiedCoin.amount;
            totalGroupBalanceUSD += modifiedCoin.balanceUSD;

            updatedCoinsInWallet.add(modifiedCoin);
          }

          updatedCoinGroups.add(
            coinsGroup.copyWith(
              coins: updatedCoinsInWallet,
              totalAmount: totalGroupAmount,
              totalBalanceUSD: totalGroupBalanceUSD,
            ),
          );
        }

        updatedViews.add(
          walletView.copyWith(
            coinGroups: updatedCoinGroups,
            usdBalance: updatedCoinGroups.fold<double>(
              0,
              (sum, group) => sum + group.totalBalanceUSD,
            ),
          ),
        );
      }

      _emitModifiedWalletViews(
        walletViews: updatedViews,
        refreshSubscriptions: false,
      );
    });
  }

  Future<void> _listenForPricesUpdate() async {
    if (_modifiedWalletViews.isEmpty) return;

    final coinIds = _modifiedWalletViews
        .expand((view) => view.coinGroups)
        .expand((group) => group.coins)
        .map((coin) => coin.coin.id)
        .toSet();

    await _pricesSubscription?.cancel();

    _pricesSubscription = _coinsRepository.watchCoins(coinIds).skip(1).listen((updatedCoins) {
      if (_modifiedWalletViews.isEmpty) return;

      final merged = [
        for (final walletView in _modifiedWalletViews)
          _mergeWalletViewWithPriceUpdates(walletView, updatedCoins),
      ];

      _emitModifiedWalletViews(walletViews: merged, refreshSubscriptions: false);
    });
  }

  Future<WalletViewData> create(String name) async {
    final request = _CreateUpdateRequestBuilder().build(name: name);
    final networks = await _networksRepository.getAllAsMap();
    final newWalletView = await _identity.wallets.createWalletView(request).then(
          (viewDTO) => _parseWalletView(viewDTO, networks, isMainWalletView: false),
        );

    _originWalletViews = [..._originWalletViews, newWalletView];
    _emitModifiedWalletViews(walletViews: _originWalletViews);

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
    );

    final updatedWalletView = await _identity.wallets.updateWalletView(walletView.id, request).then(
          (viewDTO) => _parseWalletView(
            viewDTO,
            networks,
            isMainWalletView: walletView.isMainWalletView,
          ),
        );

    final index = _originWalletViews.indexWhere((w) => w.id == walletView.id);
    index != -1
        ? _originWalletViews[index] = updatedWalletView
        : _originWalletViews.add(updatedWalletView);

    _emitModifiedWalletViews(walletViews: _originWalletViews);

    return updatedWalletView;
  }

  Future<void> delete({required String walletViewId}) async {
    await _identity.wallets.deleteWalletView(walletViewId);
    _emitModifiedWalletViews(
      walletViews: _originWalletViews.where((view) => view.id != walletViewId).toList(),
    );
  }

  // TODO: Move parsing to the separate class
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
      final network = networks[coinDTO.network]!;

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
      createdAt: viewDTO.createdAt,
      updatedAt: viewDTO.updatedAt,
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

  WalletViewData _mergeWalletViewWithPriceUpdates(
    WalletViewData walletView,
    Iterable<CoinData> updatedCoins,
  ) {
    final updatedCoinGroups = walletView.coinGroups.map((group) {
      final updatedCoinsInGroup = group.coins.map((coinInWallet) {
        final updatedCoin = updatedCoins.firstWhereOrNull(
          (coin) => coin.id == coinInWallet.coin.id,
        );

        if (updatedCoin != null) {
          final updatedBalanceUSD = coinInWallet.amount * updatedCoin.priceUSD;

          return coinInWallet.copyWith(
            coin: updatedCoin,
            balanceUSD: updatedBalanceUSD,
          );
        }

        return coinInWallet;
      }).toList();

      return group.copyWith(
        coins: updatedCoinsInGroup,
        totalBalanceUSD: updatedCoinsInGroup.fold(
          0,
          (sum, coin) => sum + coin.balanceUSD,
        ),
        totalAmount: updatedCoinsInGroup.fold(
          0,
          (sum, coin) => sum + coin.amount,
        ),
      );
    }).toList();

    return walletView.copyWith(
      coinGroups: updatedCoinGroups,
      usdBalance: updatedCoinGroups.fold(
        0,
        (sum, group) => sum + group.totalBalanceUSD,
      ),
    );
  }

  void dispose() {
    _walletViewsController.close();

    _pricesSubscription?.cancel();
    _transactionsSubscription?.cancel();
  }
}
