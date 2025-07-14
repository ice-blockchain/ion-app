// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:collection/collection.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/wallets/data/repository/transactions_repository.m.dart';
import 'package:ion/app/features/wallets/domain/transactions/sync_transactions_service.r.dart';
import 'package:ion/app/features/wallets/model/transaction_data.f.dart';
import 'package:ion/app/services/logger/logger.dart';
import 'package:ion/app/utils/retry.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'periodic_transfers_sync_service.r.g.dart';

@Riverpod(keepAlive: true)
Future<PeriodicTransfersSyncService> periodicTransfersSyncService(Ref ref) async {
  return PeriodicTransfersSyncService(
    await ref.watch(syncTransactionsServiceProvider.future),
    await ref.watch(transactionsRepositoryProvider.future),
  );
}

class PeriodicTransfersSyncService {
  PeriodicTransfersSyncService(
    this._syncTransactionsService,
    this._transactionsRepository,
  );

  final SyncTransactionsService _syncTransactionsService;
  final TransactionsRepository _transactionsRepository;

  StreamSubscription<List<TransactionData>>? _broadcastedTransfersSubscription;
  bool _isRunning = false;
  bool _isSyncInProgress = false;

  /// Starts watching for broadcasted transactions and syncing them periodically
  void startWatching() {
    if (_isRunning) return;

    _isRunning = true;
    Logger.info('Starting periodic transfers sync service');
    print(
        '[${DateTime.now().toString().substring(11, 23)}] Starting periodic transfers sync service');

    // Watch for changes in broadcasted transactions
    _broadcastedTransfersSubscription = _transactionsRepository
        .watchBroadcastedTransfers()
        .distinct((list1, list2) => const ListEquality<TransactionData>().equals(list1, list2))
        .listen(_onBroadcastedTransfersChanged);
  }

  /// Stops all timers and syncing
  void stopWatching() {
    if (!_isRunning) return;

    _isRunning = false;
    Logger.info('Stopping periodic transfers sync service');
    print(
        '[${DateTime.now().toString().substring(11, 23)}] Stopping periodic transfers sync service');

    _broadcastedTransfersSubscription?.cancel();
    _broadcastedTransfersSubscription = null;
  }

  void _onBroadcastedTransfersChanged(List<TransactionData> broadcastedTransfers) {
    if (!_isRunning) return;

    if (broadcastedTransfers.isNotEmpty) {
      final txDetails = broadcastedTransfers
          .map((tx) =>
              'txHash: ${tx.txHash}, wallet: ${tx.senderWalletAddress}, network: ${tx.network.id}')
          .join('; ');
      final message =
          'Found ${broadcastedTransfers.length} broadcasted transactions, starting sync. Details: [$txDetails]';
      Logger.info(message);
      print('[${DateTime.now().toString().substring(11, 23)}] $message');

      _startSyncing();
    }
  }

  Future<void> _startSyncing() async {
    if (_isSyncInProgress) {
      Logger.info('Transfers sync is already in progress, skip sync request');
      print(
          '[${DateTime.now().toString().substring(11, 23)}] Transfers sync is already in progress, skip sync request');
      return;
    }

    _isSyncInProgress = true;
    Logger.info('Starting periodic transfers sync');
    print('[${DateTime.now().toString().substring(11, 23)}] Starting periodic transfers sync');

    try {
      await withRetry(
        ({Object? error}) async {
          final response = await _performSync();
          return response;
        },
        initialDelay: const Duration(seconds: 30),
        maxDelay: const Duration(minutes: 30),
        multiplier: 2,
        minJitter: 2,
        maxJitter: 2,
        retryWhen: (result) => result is Exception,
      );
    } finally {
      _isSyncInProgress = false;
      Logger.info('Periodic transfers sync completed');
      print('[${DateTime.now().toString().substring(11, 23)}] Periodic transfers sync completed');
    }
  }

  Future<void> _performSync() async {
    print('[${DateTime.now().toString().substring(11, 23)}] Perform sync');

    if (!_isRunning) return;

    // Get count before sync
    final broadcastedBefore = await _transactionsRepository.getBroadcastedTransfers();
    final totalBroadcastedBefore = broadcastedBefore.length;

    if (broadcastedBefore.isEmpty) {
      Logger.info('No broadcasted transfers found during sync, skipping sync');
      print(
          '[${DateTime.now().toString().substring(11, 23)}] No broadcasted transfers found during sync, skipping sync');
      return;
    }

    final beforeDetails = broadcastedBefore
        .map((tx) =>
            'txHash: ${tx.txHash}, wallet: ${tx.senderWalletAddress}, network: ${tx.network.id}')
        .join('; ');
    final syncMessage =
        'Syncing $totalBroadcastedBefore broadcasted transfers. Details: [$beforeDetails]';
    Logger.info(syncMessage);
    print('[${DateTime.now().toString().substring(11, 23)}] $syncMessage');

    // Perform the sync
    await _syncTransactionsService.syncBroadcastedTransfers();

    // Get count after sync
    final broadcastedAfter = await _transactionsRepository.getBroadcastedTransfers();
    final totalBroadcastedAfter = broadcastedAfter.length;

    final updatedCount = totalBroadcastedBefore - totalBroadcastedAfter;
    if (updatedCount > 0) {
      final updatedTransactions = broadcastedBefore
          .where((tx) => !broadcastedAfter.any((afterTx) => afterTx.txHash == tx.txHash))
          .toList();

      final updatedDetails = updatedTransactions
          .map(
            (tx) =>
                'txHash: ${tx.txHash}, wallet: ${tx.senderWalletAddress}, network: ${tx.network.id}',
          )
          .join('; ');

      final updateMessage =
          'Transfers sync updated $updatedCount transfers from broadcasted to confirmed. Updated: [$updatedDetails]';
      Logger.info(updateMessage);
      print('[${DateTime.now().toString().substring(11, 23)}] $updateMessage');
    } else {
      Logger.info('No transfers were updated during sync');
      print(
          '[${DateTime.now().toString().substring(11, 23)}] No transfers were updated during sync');
    }

    if (totalBroadcastedAfter > 0) {
      throw Exception('$totalBroadcastedAfter transfers left to sync');
    }
  }
}
