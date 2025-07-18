// SPDX-License-Identifier: ice License 1.0

import 'package:drift/drift.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/wallets/data/database/dao/transactions_visibility_status_dao.m.dart';
import 'package:ion/app/features/wallets/data/database/tables/coins_table.d.dart';
import 'package:ion/app/features/wallets/data/database/tables/networks_table.d.dart';
import 'package:ion/app/features/wallets/data/database/tables/transactions_table.d.dart';
import 'package:ion/app/features/wallets/data/database/wallets_database.m.dart';

import 'package:ion/app/features/wallets/model/coin_data.f.dart';
import 'package:ion/app/features/wallets/model/network_data.f.dart';
import 'package:ion/app/features/wallets/model/transaction_crypto_asset.f.dart';
import 'package:ion/app/features/wallets/model/transaction_data.f.dart';
import 'package:ion/app/features/wallets/model/transaction_status.f.dart';
import 'package:ion/app/features/wallets/model/transaction_type.dart';
import 'package:ion/app/features/wallets/utils/crypto_amount_parser.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'transactions_dao.m.g.dart';

@Riverpod(keepAlive: true)
TransactionsDao transactionsDao(Ref ref) => TransactionsDao(
      db: ref.watch(walletsDatabaseProvider),
      visibilityStatusDao: ref.watch(transactionsVisibilityStatusDaoProvider),
    );

@DriftAccessor(
  tables: [TransactionsTable, NetworksTable, CoinsTable],
)
class TransactionsDao extends DatabaseAccessor<WalletsDatabase> with _$TransactionsDaoMixin {
  TransactionsDao({
    required WalletsDatabase db,
    required this.visibilityStatusDao,
  }) : super(db);

  final TransactionsVisibilityStatusDao visibilityStatusDao;

  Future<DateTime?> lastCreatedAt() async {
    final maxCreatedAt = transactionsTable.createdAtInRelay.max();
    return (selectOnly(transactionsTable)..addColumns([maxCreatedAt]))
        .map((row) => row.read(maxCreatedAt))
        .getSingleOrNull();
  }

  Future<DateTime?> getFirstCreatedAt({DateTime? after}) async {
    final firstCreatedAt = transactionsTable.createdAtInRelay.min();
    final query = selectOnly(transactionsTable)..addColumns([firstCreatedAt]);
    if (after != null) {
      query.where(transactionsTable.createdAtInRelay.isBiggerThanValue(after));
    }
    return query.map((row) => row.read(firstCreatedAt)).getSingleOrNull();
  }

  /// Returns true if there were changes in the database
  Future<bool> save(List<Transaction> transactions) {
    return transaction(() async {
      final existing = await (select(transactionsTable)
            ..where((t) => t.txHash.isIn(transactions.map((e) => e.txHash))))
          .get();

      final existingMap = {for (final e in existing) e.txHash: e};

      final newTransactions = transactions.where((t) => !existingMap.containsKey(t.txHash));
      final toInsert = transactions.map((toInsertRaw) {
        final existing = existingMap[toInsertRaw.txHash];

        if (existing == null) return toInsertRaw;

        // We don't need to update next fields after initialization
        return toInsertRaw.copyWith(
          id: Value(existing.id ?? toInsertRaw.id),
          fee: Value(existing.fee ?? toInsertRaw.fee),
          userPubkey: Value(existing.userPubkey ?? toInsertRaw.userPubkey),
          dateRequested: Value(existing.dateRequested ?? toInsertRaw.dateRequested),
          dateConfirmed: Value(existing.dateConfirmed ?? toInsertRaw.dateConfirmed),
          createdAtInRelay: Value(existing.createdAtInRelay ?? toInsertRaw.createdAtInRelay),
          transferredAmount: Value(existing.transferredAmount ?? toInsertRaw.transferredAmount),
          transferredAmountUsd: Value(
            existing.transferredAmountUsd ?? toInsertRaw.transferredAmountUsd,
          ),
        );
      });
      final updatedTransactions = toInsert.where((t) {
        final existing = existingMap[t.txHash];
        return existing != null && existing != t;
      }).toList();

      await batch((batch) {
        batch.insertAllOnConflictUpdate(transactionsTable, toInsert);
      });

      await visibilityStatusDao.addOrUpdateVisibilityStatus(transactions: transactions);

      return newTransactions.isNotEmpty || updatedTransactions.isNotEmpty;
    });
  }

  Stream<List<TransactionData>> watchTransactions({
    List<String> coinIds = const [],
    List<String> txHashes = const [],
    List<String> walletAddresses = const [],
    List<String> walletViewIds = const [],
    List<String> externalHashes = const [],
    List<String> eventIds = const [],
    List<TransactionStatus> statuses = const [],
    int limit = 20,
    int? offset,
    String? symbol,
    DateTime? confirmedSince,
    String? networkId,
  }) {
    return _createTransactionQuery(
      where: (tbl, transactionCoinAlias, nativeCoinAlias) => _buildTransactionWhereClause(
        tbl,
        coinIds: coinIds,
        txHashes: txHashes,
        walletAddresses: walletAddresses,
        walletViewIds: walletViewIds,
        externalHashes: externalHashes,
        statuses: statuses,
        symbol: symbol,
        networkId: networkId,
        confirmedSince: confirmedSince,
        transactionCoinAlias: transactionCoinAlias,
      ),
      limit: limit,
      offset: offset,
    ).watch().map((rows) => rows.toList());
  }

  Future<List<TransactionData>> getTransactions({
    List<String> coinIds = const [],
    List<String> txHashes = const [],
    List<String> walletAddresses = const [],
    List<String> walletViewIds = const [],
    List<String> externalHashes = const [],
    List<String> eventIds = const [],
    List<TransactionStatus> statuses = const [],
    int limit = 20,
    int? offset,
    String? symbol,
    String? networkId,
    DateTime? confirmedSince,
  }) async {
    return _createTransactionQuery(
      where: (tbl, transactionCoinAlias, nativeCoinAlias) => _buildTransactionWhereClause(
        tbl,
        coinIds: coinIds,
        txHashes: txHashes,
        walletAddresses: walletAddresses,
        walletViewIds: walletViewIds,
        externalHashes: externalHashes,
        statuses: statuses,
        symbol: symbol,
        networkId: networkId,
        confirmedSince: confirmedSince,
        transactionCoinAlias: transactionCoinAlias,
      ),
      limit: limit,
      offset: offset,
    ).get();
  }

  /// Creates the standard query with joins for transaction tables
  Selectable<TransactionData> _createTransactionQuery({
    required Expression<bool> Function(
      $TransactionsTableTable tbl,
      $CoinsTableTable transactionCoinAlias,
      $CoinsTableTable nativeCoinAlias,
    ) where,
    int limit = 20,
    int? offset,
  }) {
    final transactionCoinAlias = alias(coinsTable, 'transactionCoin');
    final nativeCoinAlias = alias(coinsTable, 'nativeCoin');

    final query = (select(transactionsTable)
          ..where((tbl) => where(tbl, transactionCoinAlias, nativeCoinAlias))
          ..orderBy([
            (tbl) => OrderingTerm(
                  expression: CustomExpression(
                    'COALESCE(${tbl.dateRequested.name}, ${tbl.createdAtInRelay.name}, ${tbl.dateConfirmed.name})',
                  ),
                  mode: OrderingMode.desc,
                ),
          ])
          ..limit(limit, offset: offset))
        .join([
      leftOuterJoin(
        networksTable,
        networksTable.id.equalsExp(transactionsTable.networkId),
      ),
      leftOuterJoin(
        transactionCoinAlias,
        transactionCoinAlias.id.equalsExp(transactionsTable.coinId),
      ),
      leftOuterJoin(
        nativeCoinAlias,
        nativeCoinAlias.id.equalsExp(transactionsTable.nativeCoinId),
      ),
    ]);

    return query.map(
      (row) {
        return _mapRowToDomainModel(
          row,
          nativeCoinAlias: nativeCoinAlias,
          transactionCoinAlias: transactionCoinAlias,
        );
      },
    );
  }

  /// Builds a where clause for transaction queries with common filters.
  Expression<bool> _buildTransactionWhereClause(
    $TransactionsTableTable tbl, {
    List<String> coinIds = const [],
    List<String> txHashes = const [],
    List<String> walletAddresses = const [],
    List<String> walletViewIds = const [],
    List<String> externalHashes = const [],
    List<TransactionStatus> statuses = const [],
    String? symbol,
    String? networkId,
    $CoinsTableTable? transactionCoinAlias,
    DateTime? confirmedSince,
  }) {
    Expression<bool> expr = const Constant(true);

    if (coinIds.isNotEmpty) {
      expr = expr & tbl.coinId.isIn(coinIds);
    }

    if (txHashes.isNotEmpty) {
      expr = expr & tbl.txHash.isIn(txHashes);
    }

    if (externalHashes.isNotEmpty) {
      expr = expr & tbl.externalHash.isIn(externalHashes);
    }

    if (walletViewIds.isNotEmpty) {
      expr = expr & tbl.walletViewId.isIn(walletViewIds);
    }

    if (symbol != null && transactionCoinAlias != null) {
      expr = expr & transactionCoinAlias.symbol.lower().equals(symbol.toLowerCase());
    }

    if (walletAddresses.isNotEmpty) {
      expr = expr &
          (tbl.receiverWalletAddress.isIn(walletAddresses) |
              tbl.senderWalletAddress.isIn(walletAddresses));
    }

    if (networkId != null) {
      expr = expr & tbl.networkId.equals(networkId);
    }

    if (statuses.isNotEmpty) {
      final statusStrings = statuses.map((s) => s.toJson()).toList();
      var statusExpr = tbl.status.isIn(statusStrings);

      // Include null status if broadcasted is in the list (null is treated as broadcasted)
      if (statuses.any((s) => s.isInProgress)) {
        statusExpr = statusExpr | tbl.status.isNull();
      }
      expr = expr & statusExpr;
    }

    if (confirmedSince != null) {
      expr = expr & tbl.dateConfirmed.isBiggerThanValue(confirmedSince);
    }

    return expr;
  }

  Stream<TransactionData?> watchTransactionByEventId(String eventId) async* {
    final transactionCoinAlias = alias(coinsTable, 'transactionCoin');
    final nativeCoinAlias = alias(coinsTable, 'nativeCoin');

    final query = (select(transactionsTable)..where((tbl) => tbl.eventId.equals(eventId))).join([
      leftOuterJoin(
        networksTable,
        networksTable.id.equalsExp(transactionsTable.networkId),
      ),
      leftOuterJoin(
        transactionCoinAlias,
        transactionCoinAlias.id.equalsExp(transactionsTable.coinId),
      ),
      leftOuterJoin(
        nativeCoinAlias,
        nativeCoinAlias.id.equalsExp(transactionsTable.nativeCoinId),
      ),
    ]);

    yield* query
        .map(
          (row) => _mapRowToDomainModel(
            row,
            transactionCoinAlias: transactionCoinAlias,
            nativeCoinAlias: nativeCoinAlias,
          ),
        )
        .watchSingleOrNull();
  }

  TransactionData _mapRowToDomainModel(
    TypedResult row, {
    required $CoinsTableTable nativeCoinAlias,
    required $CoinsTableTable transactionCoinAlias,
  }) {
    final transaction = row.readTable(transactionsTable);
    final network = row.readTableOrNull(networksTable);
    final nativeCoin = row.readTableOrNull(nativeCoinAlias);
    final transactionCoin = row.readTableOrNull(transactionCoinAlias);

    final domainNetwork = NetworkData.fromDB(network!);
    final transferredAmount = transaction.transferredAmount ?? '0';
    final transferredCoin = CoinData.fromDB(transactionCoin!, domainNetwork);

    return TransactionData(
      txHash: transaction.txHash,
      walletViewId: transaction.walletViewId,
      network: domainNetwork,
      type: TransactionType.fromValue(transaction.type),
      senderWalletAddress: transaction.senderWalletAddress,
      receiverWalletAddress: transaction.receiverWalletAddress,
      nativeCoin: nativeCoin != null ? CoinData.fromDB(nativeCoin, domainNetwork) : null,
      cryptoAsset: CoinTransactionAsset(
        coin: transferredCoin,
        amount: parseCryptoAmount(
          transferredAmount,
          transferredCoin.decimals,
        ),
        amountUSD: transaction.transferredAmountUsd!,
        rawAmount: transferredAmount,
      ),
      id: transaction.id,
      fee: transaction.fee,
      externalHash: transaction.externalHash,
      createdAtInRelay: transaction.createdAtInRelay,
      dateConfirmed: transaction.dateConfirmed,
      dateRequested: transaction.dateRequested,
      status: transaction.status != null
          ? TransactionStatus.fromJson(transaction.status!)
          : TransactionStatus.broadcasted,
      userPubkey: transaction.userPubkey,
    );
  }

  Future<void> remove({
    Iterable<String> txHashes = const [],
    Iterable<String> walletViewIds = const [],
  }) async {
    if (txHashes.isEmpty && walletViewIds.isEmpty) {
      return;
    }

    await transaction(() async {
      final conditions = <Expression<bool>>[];
      final deleteQuery = delete(transactionsTable);

      if (txHashes.isNotEmpty) {
        conditions.add(transactionsTable.txHash.isIn(txHashes));
      }

      if (walletViewIds.isNotEmpty) {
        conditions.add(transactionsTable.walletViewId.isIn(walletViewIds));
      }

      if (conditions.isEmpty) {
        // Should never happen, but defensive
        throw StateError('Attempted to delete transactions with no WHERE condition.');
      }

      deleteQuery.where((_) => conditions.reduce((a, b) => a & b));
      await deleteQuery.go();
    });
  }
}
