// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/wallets/data/repository/transactions_repository.c.dart';
import 'package:ion/app/features/wallets/model/transaction_data.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'external_hash_processor.c.g.dart';

@riverpod
Future<ExternalHashProcessor> externalHashProcessor(Ref ref) async {
  return ExternalHashProcessor(
    await ref.watch(transactionsRepositoryProvider.future),
  );
}

/// In some networks, after the transfer, we can get the message hash in the blockchain
/// instead of the transaction hash, but as a transaction hash. In this case,
/// the transaction data will contain both the real transaction hash (thHash)
/// and the message hash (externalHash). [ExternalHashProcessor] finds saved transactions
/// with an incorrect hash and updates the received transaction data
/// based on the data already available on the device.
class ExternalHashProcessor {
  const ExternalHashProcessor(this._transactionsRepository);

  final TransactionsRepository _transactionsRepository;

  Future<List<TransactionData>> process(List<TransactionData> transactions) async {
    final externalHashes = transactions.map((t) => t.externalHash).nonNulls.toList();
    if (externalHashes.isEmpty) return transactions;

    final savedTransactions =
        await _transactionsRepository.getTransactions(txHashes: externalHashes);
    if (savedTransactions.isEmpty) return transactions;

    final txMap = {for (final t in savedTransactions) t.txHash: t};

    return transactions.map((tx) {
      final matching = tx.externalHash != null ? txMap[tx.externalHash] : null;
      return matching != null
          ? tx.copyWith(
              userPubkey: matching.userPubkey,
              createdAtInRelay: matching.createdAtInRelay,
            )
          : tx;
    }).toList();
  }
}
