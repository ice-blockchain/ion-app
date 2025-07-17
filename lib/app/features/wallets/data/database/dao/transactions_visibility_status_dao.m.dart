// SPDX-License-Identifier: ice License 1.0

import 'package:drift/drift.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/wallets/data/database/tables/coins_table.d.dart';
import 'package:ion/app/features/wallets/data/database/tables/transaction_visibility_status_table.d.dart';
import 'package:ion/app/features/wallets/data/database/tables/transactions_table.d.dart';
import 'package:ion/app/features/wallets/data/database/wallets_database.m.dart';
import 'package:ion/app/features/wallets/model/transaction_type.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'transactions_visibility_status_dao.m.g.dart';

enum TransactionVisibilityStatus {
  unseen,
  seen,
}

@Riverpod(keepAlive: true)
TransactionsVisibilityStatusDao transactionsVisibilityStatusDao(Ref ref) =>
    TransactionsVisibilityStatusDao(db: ref.watch(walletsDatabaseProvider));

@DriftAccessor(
  tables: [
    TransactionsTable,
    CoinsTable,
    TransactionVisibilityStatusTable,
  ],
)
class TransactionsVisibilityStatusDao extends DatabaseAccessor<WalletsDatabase>
    with _$TransactionsVisibilityStatusDaoMixin {
  TransactionsVisibilityStatusDao({required WalletsDatabase db}) : super(db);

  Future<void> addOrUpdateVisibilityStatus({
    List<String> coinIds = const [],
    List<Transaction> transactions = const [],
    TransactionVisibilityStatus status = TransactionVisibilityStatus.unseen,
  }) async {
    if (coinIds.isNotEmpty) {
      await _addOrUpdateVisibilityStatusForCoinIds(coinIds, status);
    }

    if (transactions.isNotEmpty) {
      await _addOrUpdateVisibilityStatusForTransactions(transactions, status);
    }
  }

  Future<void> _addOrUpdateVisibilityStatusForCoinIds(
    List<String> coinIds,
    TransactionVisibilityStatus status,
  ) async {
    // Fetch all transactions for the given coinIds
    final transactionsForCoinIds =
        await (select(transactionsTable)..where((tbl) => tbl.coinId.isIn(coinIds))).get();

    if (transactionsForCoinIds.isEmpty) return;

    // Build a set of unique (txHash, walletViewId) pairs
    final txWalletPairs = {
      for (final t in transactionsForCoinIds) '${t.txHash}_${t.walletViewId}': t,
    };

    // Fetch existing statuses for these txHash + walletViewId pairs
    final existingStatuses = await (select(transactionVisibilityStatusTable)
          ..where(
            (tbl) =>
                tbl.txHash.isIn(txWalletPairs.values.map((t) => t.txHash)) &
                tbl.walletViewId.isIn(txWalletPairs.values.map((t) => t.walletViewId)),
          ))
        .get();

    final existingMap = <String, int>{};
    for (final row in existingStatuses) {
      final key = '${row.txHash}_${row.walletViewId}';
      existingMap[key] = row.status.index;
    }

    final inserts = <TransactionVisibilityStatusTableCompanion>[];
    final updates = <TransactionVisibilityStatusTableCompanion>[];

    for (final entry in txWalletPairs.entries) {
      final key = entry.key;
      final tx = entry.value;
      final existingStatusIndex = existingMap[key];

      if (existingStatusIndex == null) {
        // Insert new status
        inserts.add(
          TransactionVisibilityStatusTableCompanion.insert(
            status: status,
            txHash: tx.txHash,
            walletViewId: tx.walletViewId,
          ),
        );
      } else if (existingStatusIndex < status.index) {
        // Update only if the new status is higher
        updates.add(
          TransactionVisibilityStatusTableCompanion(
            status: Value(status),
            txHash: Value(tx.txHash),
            walletViewId: Value(tx.walletViewId),
          ),
        );
      }
      // If existing status is equal or higher, do nothing
    }

    await batch((batch) {
      if (inserts.isNotEmpty) {
        batch.insertAll(transactionVisibilityStatusTable, inserts);
      }
      if (updates.isNotEmpty) {
        for (final update in updates) {
          batch.update(
            transactionVisibilityStatusTable,
            update,
            where: (tbl) =>
                tbl.txHash.equals(update.txHash.value) &
                tbl.walletViewId.equals(update.walletViewId.value),
          );
        }
      }
    });
  }

  Future<void> _addOrUpdateVisibilityStatusForTransactions(
    List<Transaction> transactions,
    TransactionVisibilityStatus status,
  ) async {
    // Build a set of unique (txHash, walletViewId) pairs
    final txWalletPairs = {for (final t in transactions) '${t.txHash}_${t.walletViewId}': t};

    // Fetch existing statuses for these txHash + walletViewId pairs
    final existingStatuses = await (select(transactionVisibilityStatusTable)
          ..where(
            (tbl) =>
                tbl.txHash.isIn(txWalletPairs.values.map((t) => t.txHash)) &
                tbl.walletViewId.isIn(txWalletPairs.values.map((t) => t.walletViewId)),
          ))
        .get();

    final existingMap = <String, int>{};
    for (final row in existingStatuses) {
      final key = '${row.txHash}_${row.walletViewId}';
      existingMap[key] = row.status.index;
    }

    final inserts = <TransactionVisibilityStatusTableCompanion>[];
    final updates = <TransactionVisibilityStatusTableCompanion>[];

    for (final entry in txWalletPairs.entries) {
      final key = entry.key;
      final tx = entry.value;
      final existingStatusIndex = existingMap[key];

      if (existingStatusIndex == null) {
        // Insert new status
        inserts.add(
          TransactionVisibilityStatusTableCompanion.insert(
            status: status,
            txHash: tx.txHash,
            walletViewId: tx.walletViewId,
          ),
        );
      } else if (existingStatusIndex < status.index) {
        // Update only if the new status is higher
        updates.add(
          TransactionVisibilityStatusTableCompanion(
            status: Value(status),
            txHash: Value(tx.txHash),
            walletViewId: Value(tx.walletViewId),
          ),
        );
      }
      // If existing status is equal or higher, do nothing
    }

    await batch((batch) {
      if (inserts.isNotEmpty) {
        batch.insertAll(transactionVisibilityStatusTable, inserts);
      }
      if (updates.isNotEmpty) {
        for (final update in updates) {
          batch.update(
            transactionVisibilityStatusTable,
            update,
            where: (tbl) =>
                tbl.txHash.equals(update.txHash.value) &
                tbl.walletViewId.equals(update.walletViewId.value),
          );
        }
      }
    });
  }

  Stream<int> getAllUnseenTransactionsCount() {
    final query = (select(transactionsTable)
          ..where((tbl) => tbl.type.equals(TransactionType.receive.value)))
        .join([
      leftOuterJoin(
        transactionVisibilityStatusTable,
        transactionVisibilityStatusTable.txHash.equalsExp(transactionsTable.txHash) &
            transactionVisibilityStatusTable.walletViewId.equalsExp(transactionsTable.walletViewId),
      ),
    ]);

    // Count unseen transactions by unique coinId (across all networks)
    return query.watch().asyncMap((rows) async {
      final unseenCoins = <String>{};
      for (final row in rows) {
        final visibility = row.readTableOrNull(transactionVisibilityStatusTable);
        if (visibility == null || visibility.status == TransactionVisibilityStatus.unseen) {
          final transaction = row.readTable(transactionsTable);
          final coinId = transaction.coinId;
          if (coinId == null) continue;
          final coin = await (select(coinsTable)..where((c) => c.id.equals(coinId))).getSingle();
          {
            unseenCoins.add(coin.symbolGroup);
          }
        }
      }
      return unseenCoins.length;
    });
  }

  Stream<bool> hasUnseenTransactions(List<String> coinIds) {
    final query = (select(transactionsTable)
          ..where(
            (tbl) => tbl.coinId.isIn(coinIds) & tbl.type.equals(TransactionType.receive.value),
          ))
        .join([
      leftOuterJoin(
        transactionVisibilityStatusTable,
        transactionVisibilityStatusTable.txHash.equalsExp(transactionsTable.txHash) &
            transactionVisibilityStatusTable.walletViewId.equalsExp(transactionsTable.walletViewId),
      ),
    ]);

    return query.watch().map((rows) {
      for (final row in rows) {
        final visibility = row.readTableOrNull(transactionVisibilityStatusTable);
        if (visibility == null || visibility.status == TransactionVisibilityStatus.unseen) {
          return true;
        }
      }
      return false;
    });
  }
}
