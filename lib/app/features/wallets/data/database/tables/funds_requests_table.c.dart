// SPDX-License-Identifier: ice License 1.0

import 'package:drift/drift.dart';

@DataClassName('FundsRequest')
class FundsRequestsTable extends Table {
  @override
  Set<Column> get primaryKey => {eventId};

  TextColumn get eventId => text()();
  TextColumn get pubkey => text()();
  DateTimeColumn get createdAt => dateTime()();
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
  BoolColumn get isPending => boolean().withDefault(const Constant(true))();
  TextColumn get request => text().nullable()();
}
