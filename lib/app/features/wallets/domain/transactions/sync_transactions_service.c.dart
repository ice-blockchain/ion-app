// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/core/providers/wallets_provider.c.dart';
import 'package:ion/app/features/wallets/data/repository/crypto_wallets_repository.c.dart';
import 'package:ion/app/features/wallets/data/repository/networks_repository.c.dart';
import 'package:ion/app/features/wallets/data/repository/transactions_repository.c.dart';
import 'package:ion/app/features/wallets/model/network_data.c.dart';
import 'package:ion/app/features/wallets/model/transaction_data.c.dart';
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
  ) {
    if (_userWallets.isNotEmpty) {
      sync();
    }
  }

  final TransactionsRepository _transactionsRepository;
  final CryptoWalletsRepository _cryptoWalletsRepository;
  final NetworksRepository _networksRepository;
  final List<Wallet> _userWallets;

  Future<void> sync() async {
    final networks = await _networksRepository.getAllAsMap();
    await _userWallets.map((wallet) async {
      final network = networks[wallet.network];
      return await _cryptoWalletsRepository.isHistoryLoadedForWallet(walletId: wallet.id)
          ? _syncTransactionsByPages(wallet, network)
          : _loadAllTransactions(wallet, network);
    }).wait;
  }

  Future<void> _syncTransactionsByPages(Wallet wallet, NetworkData? network) async {
    String? nextPageToken = '';
    try {
      while (nextPageToken != null) {
        if (_canRequestHistory(wallet, network)) {
          final result = await _transactionsRepository.loadCoinTransactions(
            wallet.id,
            pageToken: nextPageToken.isEmpty ? null : nextPageToken,
          );

          nextPageToken = result.nextPageToken;

          if (result.transactions.isNotEmpty) {
            final wereAnyUpdates =
                await _transactionsRepository.saveTransactions(result.transactions);
            if (!wereAnyUpdates) nextPageToken = null;
          }
        } else {
          nextPageToken = null;
        }
      }
    } catch (ex, stacktrace) {
      Logger.error(
        ex,
        stackTrace: stacktrace,
        message: 'Failed to sync wallet(${wallet.id}) history by pages',
      );
    }
  }

  Future<void> _loadAllTransactions(Wallet wallet, NetworkData? network) async {
    String? nextPageToken = '';
    final transactions = <TransactionData>[];

    try {
      while (nextPageToken != null) {
        if (_canRequestHistory(wallet, network)) {
          final result = await _transactionsRepository.loadCoinTransactions(
            wallet.id,
            pageSize: 500,
            pageToken: nextPageToken.isEmpty ? null : nextPageToken,
          );

          nextPageToken = result.nextPageToken;

          if (result.transactions.isNotEmpty) {
            transactions.addAll(result.transactions);
          }
        } else {
          nextPageToken = null;
        }
      }

      if (transactions.isNotEmpty) {
        await _transactionsRepository.saveTransactions(transactions);
      }

      await _cryptoWalletsRepository.save(wallet: wallet, isHistoryLoaded: true);
    } catch (ex, stacktrace) {
      Logger.error(
        ex,
        stackTrace: stacktrace,
        message: 'Failed to load all transactions of the wallet(${wallet.id})',
      );
    }
  }

  bool _canRequestHistory(Wallet wallet, NetworkData? network) =>
      network != null && wallet.network == network.id && network.isIonHistorySupported;
}
