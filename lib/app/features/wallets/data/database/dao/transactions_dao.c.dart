// SPDX-License-Identifier: ice License 1.0

import 'package:drift/drift.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/wallets/data/database/tables/coins_table.c.dart';
import 'package:ion/app/features/wallets/data/database/tables/networks_table.c.dart';
import 'package:ion/app/features/wallets/data/database/tables/transactions_table.c.dart';
import 'package:ion/app/features/wallets/data/database/wallets_database.c.dart';
import 'package:ion/app/features/wallets/model/coin_data.c.dart';
import 'package:ion/app/features/wallets/model/network_data.c.dart';
import 'package:ion/app/features/wallets/model/transaction_crypto_asset.c.dart';
import 'package:ion/app/features/wallets/model/transaction_data.c.dart';
import 'package:ion/app/features/wallets/model/transaction_status.c.dart';
import 'package:ion/app/features/wallets/model/transaction_type.dart';
import 'package:ion/app/features/wallets/utils/crypto_amount_parser.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'transactions_dao.c.g.dart';

@Riverpod(keepAlive: true)
TransactionsDao transactionsDao(Ref ref) => TransactionsDao(db: ref.watch(walletsDatabaseProvider));

@DriftAccessor(tables: [TransactionsTable, NetworksTable, CoinsTable])
class TransactionsDao extends DatabaseAccessor<WalletsDatabase> with _$TransactionsDaoMixin {
  TransactionsDao({required WalletsDatabase db}) : super(db);

  Future<DateTime?> lastCreatedAt() {
    final maxCreatedAt = transactionsTable.createdAt.max();
    return (selectOnly(transactionsTable)..addColumns([maxCreatedAt]))
        .map((row) => row.read(maxCreatedAt))
        .getSingleOrNull();
  }

  Future<void> save(List<Transaction> transactions) {
    return batch((batch) {
      batch.insertAllOnConflictUpdate(transactionsTable, transactions);
    });
  }

  Future<List<TransactionData>> getBroadcastedTransfers() {
    final transactionCoinAlias = alias(coinsTable, 'transactionCoin');
    final nativeCoinAlias = alias(coinsTable, 'nativeCoin');

    final query = (select(transactionsTable)
          ..where(
            (tbl) =>
                tbl.type.equals(TransactionType.send.value) &
                tbl.id.isNotNull() &
                (tbl.status.isNull() | tbl.status.equals(TransactionStatus.broadcasted.toJson())),
          )
          ..orderBy([
            (tbl) => OrderingTerm(
                  expression: tbl.createdAt,
                  mode: OrderingMode.desc,
                ),
          ]))
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
                  tbl.transferredAmountUsd.isNotNull() &
                  tbl.balanceBeforeTransfer.isNotNull();
            },
          )
          ..orderBy([
            (tbl) => OrderingTerm(
                  expression: tbl.createdAt,
                  mode: OrderingMode.desc,
                ),
          ]))
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
      network: domainNetwork,
      type: TransactionType.fromValue(transaction.type),
      senderWalletAddress: transaction.senderWalletAddress,
      receiverWalletAddress: transaction.receiverWalletAddress,
      nativeCoin: CoinData.fromDB(nativeCoin!, domainNetwork),
      cryptoAsset: CoinTransactionAsset(
        coin: transferredCoin,
        balanceBeforeTransaction: transaction.balanceBeforeTransfer ?? '0',
        amount: parseCryptoAmount(
          transferredAmount,
          transferredCoin.decimals,
        ),
        amountUSD: transaction.transferredAmountUsd!,
        rawAmount: transferredAmount,
      ),
      id: transaction.id,
      fee: transaction.fee,
      createdAt: transaction.createdAt,
      dateConfirmed: transaction.dateConfirmed,
      status: transaction.status != null ? TransactionStatus.fromJson(transaction.status!) : null,
      userPubkey: transaction.userPubkey,
    );
  }
}
