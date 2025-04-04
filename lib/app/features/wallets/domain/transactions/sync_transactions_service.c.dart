import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/core/providers/wallets_provider.c.dart';
import 'package:ion/app/features/wallets/data/repository/crypto_wallets_repository.c.dart';
import 'package:ion/app/features/wallets/data/repository/transactions_repository.c.dart';
import 'package:ion/app/features/wallets/model/transaction_data.c.dart';
import 'package:ion_identity_client/ion_identity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sync_transactions_service.c.g.dart';

@riverpod
Future<SyncTransactionsService> syncTransactionsService(Ref ref) async {
  return SyncTransactionsService(
    await ref.watch(transactionsRepositoryProvider.future),
    await ref.watch(cryptoWalletsRepositoryProvider),
    await ref.watch(walletsNotifierProvider.future),
  );
}

class SyncTransactionsService {
  SyncTransactionsService(
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
  final List<Wallet> _userWallets;

  Future<void> sync() async {
    await _userWallets.map((wallet) async {
      return await _cryptoWalletsRepository.isHistoryLoadedForWallet(id: wallet.id)
          ? _syncTransactionsByPages(wallet)
          : _loadAllTransactions(wallet);
    }).wait;
  }

  Future<void> _syncTransactionsByPages(Wallet wallet) async {
    String? nextPageToken = '';
    while (nextPageToken != null) {
      final result = await _transactionsRepository.loadCoinTransactions(
        wallet.id,
        pageToken: nextPageToken.isEmpty ? null : nextPageToken,
      );

      nextPageToken = result.nextPageToken;

      if (result.transactions.isNotEmpty) {
        final wereAnyUpdates = await _transactionsRepository.saveTransactions(result.transactions);
        if (!wereAnyUpdates) nextPageToken = null;
      }
    }
  }

  Future<void> _loadAllTransactions(Wallet wallet) async {
    String? nextPageToken = '';
    final transactions = <TransactionData>[];

    while (nextPageToken != null) {
      final result = await _transactionsRepository.loadCoinTransactions(
        wallet.id,
        pageSize: 500,
        pageToken: nextPageToken.isEmpty ? null : nextPageToken,
      );

      nextPageToken = result.nextPageToken;

      if (result.transactions.isNotEmpty) {
        transactions.addAll(result.transactions);
      }
    }

    if (transactions.isNotEmpty) {
      await _transactionsRepository.saveTransactions(transactions);
    }

    await _cryptoWalletsRepository.save(wallet: wallet, isHistoryLoaded: true);
  }
}
