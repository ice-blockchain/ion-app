// SPDX-License-Identifier: ice License 1.0

import 'package:drift/drift.dart';
import 'package:ion/app/features/wallets/data/models/coin_data.c.dart';
import 'package:ion/app/features/wallets/data/models/database/tables/coins_table.c.dart';
import 'package:ion/app/features/wallets/data/models/database/tables/networks_table.c.dart';
import 'package:ion/app/features/wallets/data/models/database/tables/transactions_table.c.dart';
import 'package:ion/app/features/wallets/data/models/database/wallets_database.c.dart';
import 'package:ion/app/features/wallets/data/models/network_data.c.dart';
import 'package:ion/app/features/wallets/data/models/transaction_crypto_asset.c.dart';
import 'package:ion/app/features/wallets/data/models/transaction_data.c.dart';
import 'package:ion/app/features/wallets/data/models/transaction_status.c.dart';
import 'package:ion/app/features/wallets/data/models/transaction_type.dart';
import 'package:ion/app/features/wallets/utils/crypto_amount_parser.dart';

part 'transactions_dao.c.g.dart';

@DriftAccessor(tables: [TransactionsTable, NetworksTable, CoinsTable])
class TransactionsDao extends DatabaseAccessor<WalletsDatabase> with _$TransactionsDaoMixin {
  TransactionsDao({required WalletsDatabase db}) : super(db);

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

      return newTransactions.isNotEmpty || updatedTransactions.isNotEmpty;
    });
  }

  Future<List<TransactionData>> getTransactions({
    List<String> coinIds = const [],
    List<String> txHashes = const [],
    List<String> walletAddresses = const [],
    List<String> walletViewIds = const [],
    List<String> externalHashes = const [],
    int limit = 20,
    int? offset,
    String? symbol,
    String? networkId,
  }) async {
    final transactionCoinAlias = alias(coinsTable, 'transactionCoin');
    final nativeCoinAlias = alias(coinsTable, 'nativeCoin');

    final query = (select(transactionsTable)
          ..where((tbl) {
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

            if (symbol != null) {
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

            return expr;
          })
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

    return query.map((row) {
      return _mapRowToDomainModel(
        row,
        nativeCoinAlias: nativeCoinAlias,
        transactionCoinAlias: transactionCoinAlias,
      );
    }).get();
  }

  Future<List<TransactionData>> getBroadcastedTransfers({String? walletAddress}) {
    final transactionCoinAlias = alias(coinsTable, 'transactionCoin');
    final nativeCoinAlias = alias(coinsTable, 'nativeCoin');

    final query = (select(transactionsTable)
          ..where((tbl) {
            var expr = tbl.type.equals(TransactionType.send.value) &
                tbl.id.isNotNull() &
                (tbl.status.isNull() | tbl.status.equals(TransactionStatus.broadcasted.toJson()));

            if (walletAddress != null) {
              expr = expr & tbl.senderWalletAddress.equals(walletAddress);
            }

            return expr;
          }))
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

    return query.map((row) {
      return _mapRowToDomainModel(
        row,
        nativeCoinAlias: nativeCoinAlias,
        transactionCoinAlias: transactionCoinAlias,
      );
    }).get();
  }

  Stream<Map<CoinData, List<TransactionData>>> watchBroadcastedTransfersByCoins(
    List<String> coinIds,
  ) {
    final transactionCoinAlias = alias(coinsTable, 'transactionCoin');
    final nativeCoinAlias = alias(coinsTable, 'nativeCoin');

    final query = (select(transactionsTable)
          ..where(
            (tbl) {
              return tbl.coinId.isIn(coinIds) &
                  tbl.networkId.isNotNull() &
                  tbl.type.equals(TransactionType.send.value) &
                  (tbl.status.isNull() |
                      tbl.status.equals(TransactionStatus.broadcasted.toJson())) &
                  tbl.transferredAmount.isNotNull() &
                  tbl.transferredAmountUsd.isNotNull();
            },
          ))
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

    return query
        .watch()
        .map(
          (rows) => rows.map(
            (row) => _mapRowToDomainModel(
              row,
              nativeCoinAlias: nativeCoinAlias,
              transactionCoinAlias: transactionCoinAlias,
            ),
          ),
        )
        .map((transactions) {
      final transactionsByCoin = <CoinData, List<TransactionData>>{};

      for (final transaction in transactions) {
        final coin = (transaction.cryptoAsset as CoinTransactionAsset).coin;
        transactionsByCoin.putIfAbsent(coin, () => []).add(transaction);
      }

      return transactionsByCoin;
    });
  }

  Future<TransactionData?> getTransactionByTxHash(String txHash) {
    final transactionCoinAlias = alias(coinsTable, 'transactionCoin');
    final nativeCoinAlias = alias(coinsTable, 'nativeCoin');

    final query = (select(transactionsTable)..where((tbl) => tbl.txHash.equals(txHash))).join([
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

    return query
        .map(
          (row) => _mapRowToDomainModel(
            row,
            transactionCoinAlias: transactionCoinAlias,
            nativeCoinAlias: nativeCoinAlias,
          ),
        )
        .getSingleOrNull();
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
