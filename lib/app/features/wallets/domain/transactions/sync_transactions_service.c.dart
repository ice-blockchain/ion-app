// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:collection/collection.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/core/providers/wallets_provider.c.dart';
import 'package:ion/app/features/wallets/data/repository/crypto_wallets_repository.c.dart';
import 'package:ion/app/features/wallets/data/repository/networks_repository.c.dart';
import 'package:ion/app/features/wallets/data/repository/transactions_repository.c.dart';
import 'package:ion/app/features/wallets/model/network_data.c.dart';
import 'package:ion/app/features/wallets/model/transaction_data.c.dart';
import 'package:ion/app/features/wallets/model/transaction_status.c.dart';
import 'package:ion/app/services/logger/logger.dart';
import 'package:ion_identity_client/ion_identity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sync_transactions_service.c.g.dart';

@riverpod
Future<SyncTransactionsService> syncTransactionsService(Ref ref) async {
  return SyncTransactionsService(
    ref.watch(networksRepositoryProvider),
    await ref.watch(transactionsRepositoryProvider.future),
    await ref.watch(cryptoWalletsRepositoryProvider),
    await ref.watch(walletsNotifierProvider.future),
  );
}

/// Loads the available wallet history, and on subsequent calls, synchronizes it.
/// In case of an error, logs it and skips the wallet.
class SyncTransactionsService {
  SyncTransactionsService(
    this._networksRepository,
    this._transactionsRepository,
    this._cryptoWalletsRepository,
    this._userWallets,
  );

  final TransactionsRepository _transactionsRepository;
  final CryptoWalletsRepository _cryptoWalletsRepository;
  final NetworksRepository _networksRepository;
  final List<Wallet> _userWallets;

  Future<void> sync() async {
    final networks = await _networksRepository.getAllAsMap();
    await _userWallets.map((wallet) async {
      final network = networks[wallet.network];
      final isHistoryLoaded =
          await _cryptoWalletsRepository.isHistoryLoadedForWallet(walletId: wallet.id);

      isHistoryLoaded
          ? await _syncTransactions(wallet, network)
          : await _loadAllTransactions(wallet, network);
    }).wait;
  }

  Future<void> _syncTransactions(Wallet wallet, NetworkData? network) async {
    if (network == null) return;

    var wasHistorySyncSuccessful = false;

    if (network.isIonHistorySupported) {
      wasHistorySyncSuccessful = await _loadTransactions(wallet, isFullLoad: false);
    }

    if (!wasHistorySyncSuccessful) {
      await _updateBroadcastedTransfers(wallet);
    }
  }

  Future<void> _loadAllTransactions(Wallet wallet, NetworkData? network) async {
    if (network == null) {
      await _cryptoWalletsRepository.save(wallet: wallet, isHistoryLoaded: true);
      return;
    }

    var wasHistorySyncSuccessful = false;

    if (network.isIonHistorySupported) {
      wasHistorySyncSuccessful = await _loadTransactions(wallet, isFullLoad: true);
    }

    if (!wasHistorySyncSuccessful) {
      await _updateBroadcastedTransfers(wallet);
    }

    await _cryptoWalletsRepository.save(wallet: wallet, isHistoryLoaded: true);
  }

  // Return true if the load was successful
  Future<bool> _loadTransactions(Wallet wallet, {required bool isFullLoad}) async {
    String? nextPageToken = '';
    final transactions = <TransactionData>[];

    try {
      while (nextPageToken != null) {
        final result = await _transactionsRepository.loadCoinTransactions(
          wallet.id,
          pageSize: isFullLoad ? 500 : null,
          pageToken: nextPageToken.isEmpty ? null : nextPageToken,
        );

        nextPageToken = result.nextPageToken;

        if (result.transactions.isNotEmpty) {
          if (isFullLoad) {
            transactions.addAll(result.transactions);
          } else {
            final updated = await _transactionsRepository.saveTransactions(result.transactions);
            // The first page of history is the same, as we have in DB.
            // We can stop loading synchronization.
            if (!updated || nextPageToken == null) {
              return true;
            }
          }
        }
      }

      if (isFullLoad && transactions.isNotEmpty) {
        await _transactionsRepository.saveTransactions(transactions);
      }

      return true;
    } catch (ex, stacktrace) {
      Logger.error(
        ex,
        stackTrace: stacktrace,
        message:
            'Failed to ${isFullLoad ? 'load all' : 'sync'} transactions of the wallet(${wallet.id})',
      );
    }

    return false;
  }

  /// We cannot sync transactions for the tier 2 networks,
  /// but we still can update status for transfers in these networks.
  Future<void> _updateBroadcastedTransfers(Wallet wallet) async {
    String? nextPageToken = '';

    final broadcastedTransfers =
        await _transactionsRepository.getBroadcastedTransfers(walletAddress: wallet.address);

    if (broadcastedTransfers.isEmpty) {
      return;
    }

    final updatedTransfers = <TransactionData>[];

    try {
      while (nextPageToken != null) {
        final result = await _transactionsRepository.loadTransfers(
          wallet.id,
          pageToken: nextPageToken.isEmpty ? null : nextPageToken,
        );

        nextPageToken = result.nextPageToken;

        final filtered =
            result.items.where((e) => e.txHash != null && e.requestBody is CoinTransferRequestBody);

        for (final transfer in filtered) {
          // Find the transfer that matches the transaction in the DB
          final transferTransaction =
              broadcastedTransfers.firstWhereOrNull((t) => t.txHash == transfer.txHash);

          // Update status for this transaction and remove it from broadcasted transfers list
          if (transferTransaction != null) {
            updatedTransfers.add(
              transferTransaction.copyWith(
                status: TransactionStatus.fromJson(transfer.status),
                dateConfirmed: transfer.dateConfirmed,
              ),
            );
            broadcastedTransfers.remove(transferTransaction);
          }
        }

        // Since list of transfers to update is empty, we can stop sync
        if (broadcastedTransfers.isEmpty) {
          nextPageToken = null;
        }
      }
    } catch (ex, stacktrace) {
      Logger.error(
        ex,
        stackTrace: stacktrace,
        message: 'Failed to load transfers of the wallet(${wallet.id})',
      );
    }

    if (updatedTransfers.isNotEmpty) {
      await _transactionsRepository.saveTransactions(updatedTransfers);
    }
  }
}
