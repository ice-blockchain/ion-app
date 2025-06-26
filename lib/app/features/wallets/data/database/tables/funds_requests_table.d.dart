// SPDX-License-Identifier: ice License 1.0

import 'package:drift/drift.dart';
import 'package:ion/app/features/wallets/data/database/tables/transactions_table.d.dart';

@DataClassName('FundsRequest')
class FundsRequestsTable extends Table {
  @override
  Set<Column> get primaryKey => {eventId};

  TextColumn get eventId => text()();
  TextColumn get pubkey => text()();
  IntColumn get createdAt => integer()();
  TextColumn get networkId => text()();
  TextColumn get assetClass => text()();
  TextColumn get assetAddress => text()();
  TextColumn get from => text()();
  TextColumn get to => text()();
  TextColumn get walletAddress => text().nullable()();
  TextColumn get userPubkey => text().nullable()();
  TextColumn get assetId => text().nullable()();
  TextColumn get amount => text().nullable()();
  TextColumn get amountUsd => text().nullable()();
  TextColumn get transactionId => text().nullable().references(TransactionsTable, #txHash)();
  TextColumn get request => text().nullable()();
}
