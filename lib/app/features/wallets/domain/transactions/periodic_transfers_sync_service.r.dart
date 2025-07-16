// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:collection/collection.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/wallets/data/repository/transactions_repository.m.dart';
import 'package:ion/app/features/wallets/domain/transactions/sync_transactions_service.r.dart';
import 'package:ion/app/features/wallets/model/network_data.f.dart';
import 'package:ion/app/features/wallets/model/transaction_data.f.dart';
import 'package:ion/app/features/wallets/model/transaction_status.f.dart';
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
    Logger.log('Starting periodic transfers sync service');

    _broadcastedTransfersSubscription = _transactionsRepository
        .watchTransactions(
          statuses: [
            TransactionStatus.pending,
            TransactionStatus.executing,
            TransactionStatus.broadcasted,
          ],
          limit: 100,
        )
        .distinct((list1, list2) => const ListEquality<TransactionData>().equals(list1, list2))
        .listen(_onPendingTransactionsChanged);
  }

  void stopWatching() {
    if (!_isRunning) return;

    _isRunning = false;
    Logger.log('Stopping periodic transfers sync service');

    _broadcastedTransfersSubscription?.cancel();
    _broadcastedTransfersSubscription = null;
  }

  void _onPendingTransactionsChanged(List<TransactionData> pendingTransactions) {
    if (!_isRunning) return;

    if (pendingTransactions.isNotEmpty) {
      final txDetails = pendingTransactions
          .map(
            (tx) =>
                'txHash: ${tx.txHash}, network: ${tx.network.id}, type: ${tx.type.value}, status: ${tx.status}, wallet: ${tx.type.isSend ? tx.senderWalletAddress : tx.receiverWalletAddress}',
          )
          .join('\n');
      final message =
          'Found ${pendingTransactions.length} pending transactions, starting sync. Details:\n[$txDetails]';
      Logger.log(message);

      _startSyncing();
    }
  }

  Future<void> _startSyncing() async {
    Logger.log('Starting wallet-specific periodic transfers sync');

    final pendingTransactions = await _transactionsRepository.getTransactions(
      statuses: [
        TransactionStatus.pending,
        TransactionStatus.executing,
        TransactionStatus.broadcasted,
      ],
      limit: 100,
    );

    if (pendingTransactions.isEmpty) {
      Logger.log('No pending transactions found, skipping sync');
      return;
    }

    // Group wallets by address and extract their networks
    final walletNetworks = <String, NetworkData>{};

    // Add wallets from all pending transactions
    for (final tx in pendingTransactions) {
      // Choose the appropriate wallet address based on transaction type
      final walletAddress = tx.type.isSend ? tx.senderWalletAddress : tx.receiverWalletAddress;
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
      Logger.log('Wallet $walletAddress sync is already in progress, skipping');
      return;
    }

    _walletSyncInProgress[walletAddress] = true;

    Logger.log('Starting periodic sync for wallet $walletAddress in ${network.id}');

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
        retryWhen: (result) => result is WalletSyncRetryException,
      );
    } finally {
      _walletSyncInProgress[walletAddress] = false;
      Logger.log('Periodic sync completed for wallet $walletAddress (${network.id})');
    }
  }

  Future<void> _performWalletSync(String walletAddress) async {
    if (!_isRunning) return;

    final pendingTransactionsBefore = await _transactionsRepository.getTransactions(
      walletAddresses: [walletAddress],
      statuses: [
        TransactionStatus.pending,
        TransactionStatus.executing,
        TransactionStatus.broadcasted,
      ],
      limit: 100,
    );

    final totalTransactionsBefore = pendingTransactionsBefore.length;

    if (pendingTransactionsBefore.isEmpty) {
      Logger.log('No pending transactions found for wallet $walletAddress, skipping sync');
      return;
    }

    final beforeDetails = pendingTransactionsBefore
        .map(
          (tx) =>
              '${tx.type.value}: txHash (${tx.txHash}) status (${tx.status}) in ${tx.network.id}',
        )
        .join('; ');
    final syncMessage =
        'Syncing $totalTransactionsBefore pending transactions for wallet $walletAddress. Details: \n[$beforeDetails]';
    Logger.log(syncMessage);

    await _syncTransactionsService.syncBroadcastedTransactionsForWallet(walletAddress);

    final pendingTransactionsAfter = await _transactionsRepository.getTransactions(
      walletAddresses: [walletAddress],
      statuses: [
        TransactionStatus.pending,
        TransactionStatus.executing,
        TransactionStatus.broadcasted,
      ],
      limit: 100,
    );

    final totalTransactionsAfter = pendingTransactionsAfter.length;
    final updatedCount = totalTransactionsBefore - totalTransactionsAfter;

    if (updatedCount > 0) {
      final updatedTransactions = pendingTransactionsBefore
          .where((tx) => !pendingTransactionsAfter.any((afterTx) => afterTx.txHash == tx.txHash))
          .toList();

      final updatedDetails = updatedTransactions
          .map((tx) => '${tx.type.value}: txHash (${tx.txHash}) in ${tx.network.id}')
          .join('\n');

      final updateMessage =
          'Wallet $walletAddress sync updated $updatedCount transactions to confirmed. Updated: [$updatedDetails]';
      Logger.log(updateMessage);
    } else {
      Logger.log('No transactions were updated during sync for wallet $walletAddress');
    }

    if (totalTransactionsAfter > 0) {
      throw WalletSyncRetryException(
        walletAddress: walletAddress,
        remainingTransfers: totalTransactionsAfter,
      );
    }
  }
}
