// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:collection/collection.dart';
import 'package:ion/app/extensions/object.dart';
import 'package:ion/app/features/wallets/data/repository/transactions_repository.m.dart';
import 'package:ion/app/features/wallets/model/coin_in_wallet_data.f.dart';
import 'package:ion/app/features/wallets/model/coin_transaction_data.f.dart';
import 'package:ion/app/features/wallets/model/coin_transaction_history_state.f.dart';
import 'package:ion/app/features/wallets/model/network_data.f.dart';
import 'package:ion/app/features/wallets/model/transaction_crypto_asset.f.dart';
import 'package:ion/app/features/wallets/model/transaction_data.f.dart';
import 'package:ion/app/features/wallets/model/transaction_status.f.dart';
import 'package:ion/app/features/wallets/providers/connected_crypto_wallets_provider.r.dart';
import 'package:ion/app/features/wallets/providers/synced_coins_by_symbol_group_provider.r.dart';
import 'package:ion/app/features/wallets/providers/wallet_view_data_provider.r.dart';
import 'package:ion/app/features/wallets/views/pages/coins_flow/coin_details/providers/network_selector_notifier.r.dart';
import 'package:ion/app/services/logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'coin_transaction_history_notifier_provider.r.g.dart';

@riverpod
class CoinTransactionHistoryNotifier extends _$CoinTransactionHistoryNotifier {
  static const int _pageSize = 20;
  static const String _tag = 'CoinTransactionHistory: ';

  late List<String> _coinWalletAddresses;
  late List<CoinInWalletData> _coins;
  late String _walletViewId;

  List<CoinTransactionData> _history = [];
  NetworkData? _network;
  var _offset = 0;
  DateTime? _lastLoadTime;

  StreamSubscription<List<TransactionData>>? _newTransactionsWatcher;
  StreamSubscription<List<TransactionData>>? _inProgressTransactionsWatcher;

  @override
  Future<CoinTransactionHistoryState> build({required String symbolGroup}) async {
    await _cancelWatchers();

    try {
      await _initializeData(symbolGroup);
      final initialState = await _loadInitialTransactions();
      await _startRealtimeWatching();

      return initialState;
    } catch (error, stackTrace) {
      Logger.error('$_tag Failed to initialize: $error', stackTrace: stackTrace);
      return const CoinTransactionHistoryState(
        transactions: [],
        isLoading: false,
        hasMore: false,
      );
    }
  }

  Future<void> _initializeData(String symbolGroup) async {
    _walletViewId = await ref.watch(currentWalletViewIdProvider.future);
    _coins = await ref.watch(syncedCoinsBySymbolGroupProvider(symbolGroup).future);
    _coinWalletAddresses = await ref
        .watch(walletViewCryptoWalletsProvider().future)
        .then((wallets) => wallets.map((w) => w.address).nonNulls.toList());

    _network = ref.watch(
      networkSelectorNotifierProvider(symbolGroup: symbolGroup).select(
        (state) => state?.selected.whenOrNull(network: (network) => network),
      ),
    );

    _reset();

    ref.onDispose(() async {
      await _cancelWatchers();
    });
  }

  void _reset() {
    Logger.info('$_tag Resetting history due to dependency changes');
    _offset = 0;
    _history = [];
    _lastLoadTime = null;
  }

  Future<void> _cancelWatchers() async {
    await _newTransactionsWatcher?.cancel();
    await _inProgressTransactionsWatcher?.cancel();
    _newTransactionsWatcher = null;
    _inProgressTransactionsWatcher = null;
  }

  Future<CoinTransactionHistoryState> _loadInitialTransactions() async {
    if (!_canLoadTransactions()) {
      return const CoinTransactionHistoryState(
        transactions: [],
        isLoading: false,
        hasMore: false,
      );
    }

    final repository = await ref.read(transactionsRepositoryProvider.future);
    final coinIds = _getFilteredCoinIds();

    Logger.info(
      '$_tag Loading initial transactions with params: '
      'offset: $_offset, network: ${_network?.id}, walletViewId: $_walletViewId, '
      'coinIds: $coinIds, walletAddresses: $_coinWalletAddresses',
    );

    final transactions = await repository.getTransactions(
      offset: _offset,
      network: _network,
      walletViewIds: [_walletViewId],
      coinIds: coinIds,
      walletAddresses: _coinWalletAddresses,
    );

    _lastLoadTime = DateTime.now();
    _processTransactions(transactions);

    return CoinTransactionHistoryState(
      transactions: _history,
      isLoading: false,
      hasMore: transactions.length >= _pageSize,
    );
  }

  Future<void> _startRealtimeWatching() async {
    if (!_canLoadTransactions() || _lastLoadTime == null) return;

    final repository = await ref.read(transactionsRepositoryProvider.future);
    final coinIds = _getFilteredCoinIds();

    // Stream 1: Watch for new transactions (both in-progress and confirmed) since initial load
    _newTransactionsWatcher = repository
        .watchTransactions(
          coinIds: coinIds,
          network: _network,
          walletViewIds: [_walletViewId],
          walletAddresses: _coinWalletAddresses,
          statuses: [
            ...TransactionStatus.inProgressStatuses,
            TransactionStatus.confirmed,
          ],
          confirmedSince: _lastLoadTime,
        )
        .distinct((list1, list2) => const ListEquality<TransactionData>().equals(list1, list2))
        .listen(_onNewTransactionsReceived, onError: _onWatcherError);

    // Stream 2: Watch for in-progress transaction status updates
    _inProgressTransactionsWatcher = repository
        .watchTransactions(
          coinIds: coinIds,
          network: _network,
          walletViewIds: [_walletViewId],
          walletAddresses: _coinWalletAddresses,
          statuses: TransactionStatus.inProgressStatuses,
          limit: 100, // 100 for rare cases, on average no more than 20 is expected
        )
        .distinct((list1, list2) => const ListEquality<TransactionData>().equals(list1, list2))
        .listen(_onInProgressTransactionsUpdated, onError: _onWatcherError);

    Logger.info('$_tag Started real-time watching for new and in-progress transactions');
  }

  void _onNewTransactionsReceived(List<TransactionData> transactions) {
    Logger.info('$_tag Received ${transactions.length} new transactions');

    var hasNewTransactions = false;
    final updatedHistory = List<CoinTransactionData>.from(_history);

    for (final tx in transactions) {
      if (!_isValidTransaction(tx)) continue;

      final coinTransactionData = _convertToCoinTransactionData(tx);
      if (coinTransactionData == null) continue;

      // Check if transaction already exists
      final existingIndex = updatedHistory
          .indexWhere((h) => h.origin.txHash == tx.txHash || h.origin.txHash == tx.externalHash);

      if (existingIndex == -1) {
        // Add new transaction at the beginning
        updatedHistory.insert(0, coinTransactionData);
        hasNewTransactions = true;
        Logger.info('$_tag Added new transaction: ${tx.txHash} (${tx.status})');
      }
    }

    if (hasNewTransactions) {
      _history = updatedHistory;
      _updateState();
    }
  }

  void _onInProgressTransactionsUpdated(List<TransactionData> transactions) {
    Logger.info('$_tag Checking ${transactions.length} in-progress transactions for updates');

    var hasUpdates = false;
    final updatedHistory = List<CoinTransactionData>.from(_history);

    for (final tx in transactions) {
      if (!_isValidTransaction(tx, allowDuplicates: true)) continue;

      final coinTransactionData = _convertToCoinTransactionData(tx);
      if (coinTransactionData == null) continue;

      final existingIndex = updatedHistory
          .indexWhere((h) => h.origin.txHash == tx.txHash || h.origin.txHash == tx.externalHash);

      if (existingIndex >= 0) {
        // Update existing transaction if status, amount, or other data changed
        final existingTx = updatedHistory[existingIndex];
        if (_hasTransactionStatusChanged(existingTx, coinTransactionData)) {
          updatedHistory[existingIndex] = coinTransactionData;
          hasUpdates = true;
          Logger.info('$_tag Updated in-progress transaction: ${tx.txHash} -> ${tx.status}');
        }
      } else {
        // Add new in-progress transaction
        updatedHistory.insert(0, coinTransactionData);
        hasUpdates = true;
        Logger.info('$_tag Added new in-progress transaction: ${tx.txHash}');
      }
    }

    if (hasUpdates) {
      // Sort to maintain chronological order (newest first)
      updatedHistory.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      _history = updatedHistory;
      _updateState();
    }
  }

  bool _hasTransactionStatusChanged(CoinTransactionData existing, CoinTransactionData updated) {
    return existing.origin.status != updated.origin.status;
  }

  void _onWatcherError(Object error, StackTrace stackTrace) {
    Logger.error('$_tag Real-time transactions watcher error: $error', stackTrace: stackTrace);
  }

  Future<void> loadMore() async {
    final currentState = state.value;
    if (currentState == null || !currentState.hasMore || currentState.isLoading) {
      return;
    }

    _updateState();

    try {
      final repository = await ref.read(transactionsRepositoryProvider.future);
      final coinIds = _getFilteredCoinIds();

      Logger.info('$_tag Loading more transactions from offset: $_offset');

      final transactions = await repository.getTransactions(
        offset: _offset,
        network: _network,
        walletViewIds: [_walletViewId],
        coinIds: coinIds,
        walletAddresses: _coinWalletAddresses,
      );

      _processTransactions(transactions);

      _updateState(hasMore: transactions.length >= _pageSize);
    } catch (error, stackTrace) {
      Logger.error('$_tag Failed to load more transactions: $error', stackTrace: stackTrace);
      _updateState();
    }
  }

  List<String> _getFilteredCoinIds() {
    return _coins
        .where((coin) => _network == null || coin.coin.network == _network)
        .map((c) => c.coin.id)
        .toList();
  }

  bool _canLoadTransactions() {
    if (_coinWalletAddresses.isEmpty) {
      Logger.warning('$_tag Wallet addresses list is empty');
      return false;
    }
    return true;
  }

  void _processTransactions(List<TransactionData> transactions) {
    _offset += transactions.length;

    final validTransactions = transactions
        .where(_isValidTransaction)
        .map(_convertToCoinTransactionData)
        .nonNulls
        .toList();

    _history.addAll(validTransactions);
  }

  CoinTransactionData? _convertToCoinTransactionData(TransactionData t) {
    final asset = t.cryptoAsset.as<CoinTransactionAsset>();
    if (asset == null) {
      Logger.warning('$_tag Unexpected null CoinTransactionAsset for transaction: ${t.id}');
      return null;
    }

    final timestamp = t.dateRequested ?? t.createdAtInRelay ?? t.dateConfirmed;
    if (timestamp == null) {
      Logger.warning('$_tag Unexpected null timestamp for transaction: ${t.id}');
      return null;
    }

    return CoinTransactionData(
      network: t.network,
      transactionType: t.type,
      coinAmount: asset.amount,
      usdAmount: asset.amountUSD,
      timestamp: timestamp.millisecondsSinceEpoch,
      origin: t,
    );
  }

  bool _isValidTransaction(TransactionData tx, {bool allowDuplicates = false}) {
    if (tx.cryptoAsset is! CoinTransactionAsset) {
      Logger.warning('$_tag Ignored non-coin transaction: ${tx.txHash}');
      return false;
    }

    final hasTimestamp =
        tx.dateRequested != null || tx.createdAtInRelay != null || tx.dateConfirmed != null;
    if (!hasTimestamp) {
      Logger.warning('$_tag Ignored transaction with missing date: ${tx.txHash}');
      return false;
    }

    if (!allowDuplicates && _history.any((h) => h.origin.txHash == tx.txHash)) {
      return false; // Skip duplicate without warning for real-time updates
    }

    return true;
  }

  void _updateState({bool? hasMore}) {
    final currentState = state.value;
    if (currentState == null) return;

    state = AsyncValue.data(
      currentState.copyWith(
        transactions: _history,
        isLoading: false,
        hasMore: hasMore ?? currentState.hasMore,
      ),
    );
  }
}
