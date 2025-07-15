// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:collection/collection.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/wallets/data/repository/transactions_repository.m.dart';
import 'package:ion/app/features/wallets/domain/transactions/sync_transactions_service.r.dart';
import 'package:ion/app/features/wallets/model/network_data.f.dart';
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
  final Map<String, bool> _walletSyncInProgress = {};

  StreamSubscription<List<TransactionData>>? _broadcastedTransfersSubscription;
  bool _isRunning = false;

  void startWatching() {
    if (_isRunning) return;

    _isRunning = true;
    Logger.info('Starting periodic transfers sync service');

    _broadcastedTransfersSubscription = _transactionsRepository
        .watchBroadcastedTransfers()
        .distinct((list1, list2) => const ListEquality<TransactionData>().equals(list1, list2))
        .listen(_onBroadcastedTransfersChanged);
  }

  void stopWatching() {
    if (!_isRunning) return;

    _isRunning = false;
    Logger.info('Stopping periodic transfers sync service');

    _broadcastedTransfersSubscription?.cancel();
    _broadcastedTransfersSubscription = null;
  }

  void _onBroadcastedTransfersChanged(List<TransactionData> broadcastedTransfers) {
    if (!_isRunning) return;

    if (broadcastedTransfers.isNotEmpty) {
      final txDetails = broadcastedTransfers
          .map(
            (tx) =>
                'txHash: ${tx.txHash}, network: ${tx.network.id}, wallet: ${tx.senderWalletAddress}',
          )
          .join('\n');
      final message =
          'Found ${broadcastedTransfers.length} broadcasted transactions, starting sync. Details:\n[$txDetails]';
      Logger.info(message);

      _startSyncing();
    }
  }

  Future<void> _startSyncing() async {
    Logger.info('Starting wallet-specific periodic transfers sync');

    final broadcastedTransfers = await _transactionsRepository.getBroadcastedTransfers();

    if (broadcastedTransfers.isEmpty) {
      Logger.info('No broadcasted transfers found, skipping sync');
      return;
    }

    // Group wallets by address and extract their networks
    final walletNetworks = <String, NetworkData>{};
    for (final tx in broadcastedTransfers) {
      final walletAddress = tx.senderWalletAddress;
      if (walletAddress != null && !walletNetworks.containsKey(walletAddress)) {
        walletNetworks[walletAddress] = tx.network;
      }
    }

    final syncFutures = walletNetworks.entries.map(
      (entry) => _startWalletSync(walletAddress: entry.key, network: entry.value),
    );
    await Future.wait(syncFutures);
  }

  Future<void> _startWalletSync({
    required String walletAddress,
    required NetworkData network,
  }) async {
    if (_walletSyncInProgress[walletAddress] ?? false) {
      Logger.info('Wallet $walletAddress sync is already in progress, skipping');
      return;
    }

    _walletSyncInProgress[walletAddress] = true;

    Logger.info('Starting periodic sync for wallet $walletAddress in ${network.id}');

    try {
      // Exponential backoff delay progression:
      // 30s → 1m → 2m → 4m → 8m → 16m → 30m (capped) → 30m → 30m...
      await withRetry(
        ({Object? error}) => _performWalletSync(walletAddress),
        initialDelay: const Duration(seconds: 30),
        maxDelay: const Duration(minutes: 30),
        multiplier: 2,
        minJitter: 2,
        maxJitter: 2,
        retryWhen: (result) => result is Exception,
      );
    } finally {
      _walletSyncInProgress[walletAddress] = false;
      Logger.log('Periodic sync completed for wallet $walletAddress (${network.id})');
    }
  }

  Future<void> _performWalletSync(String walletAddress) async {
    if (!_isRunning) return;

    // Get current broadcasted transfers for this wallet
    final broadcastedBefore = await _transactionsRepository.getBroadcastedTransfers(
      walletAddress: walletAddress,
    );
    final totalBroadcastedBefore = broadcastedBefore.length;

    if (broadcastedBefore.isEmpty) {
      Logger.log('No broadcasted transfers found for wallet $walletAddress, skipping sync');
      return;
    }

    final beforeDetails =
        broadcastedBefore.map((tx) => 'txHash (${tx.txHash}) in ${tx.network.id}').join('; ');
    final syncMessage =
        'Syncing $totalBroadcastedBefore broadcasted transfers for wallet $walletAddress. Details: \n[$beforeDetails]';
    Logger.log(syncMessage);

    // Perform the sync for this specific wallet
    await _syncTransactionsService.syncBroadcastedTransfersForWallet(walletAddress);

    // Get count after sync for this wallet
    final broadcastedAfter = await _transactionsRepository.getBroadcastedTransfers(
      walletAddress: walletAddress,
    );
    final totalBroadcastedAfter = broadcastedAfter.length;

    final updatedCount = totalBroadcastedBefore - totalBroadcastedAfter;
    if (updatedCount > 0) {
      final updatedTransactions = broadcastedBefore
          .where((tx) => !broadcastedAfter.any((afterTx) => afterTx.txHash == tx.txHash))
          .toList();

      final updatedDetails =
          updatedTransactions.map((tx) => 'txHash (${tx.txHash}) in ${tx.network.id}').join('\n');

      final updateMessage =
          'Wallet $walletAddress sync updated $updatedCount transfers from broadcasted to confirmed. Updated: [$updatedDetails]';
      Logger.log(updateMessage);
    } else {
      Logger.log('No transfers were updated during sync for wallet $walletAddress');
    }

    if (totalBroadcastedAfter > 0) {
      throw WalletSyncRetryException(
        walletAddress: walletAddress,
        remainingTransfers: totalBroadcastedAfter,
      );
    }
  }
}
