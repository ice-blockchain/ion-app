// SPDX-License-Identifier: ice License 1.0

import 'package:drift/drift.dart';

@DataClassName('Transaction')
class TransactionsTable extends Table {
  // Transaction required fields
  TextColumn get type => text()(); // In, Out
  TextColumn get txHash => text()();
  TextColumn get networkId => text()();
  // Can be the same, as native one. Null if asset is nft.
  TextColumn get coinId => text().nullable()();
  TextColumn get senderWalletAddress => text()();
  TextColumn get receiverWalletAddress => text()();

  // Fields, that will be available from ion service
  TextColumn get id => text().nullable()();
  TextColumn get fee => text().nullable()();
  TextColumn get status => text().nullable()();
  TextColumn get nativeCoinId => text().nullable()(); // to get decimals to calculate fee
  DateTimeColumn get dateConfirmed => dateTime().nullable().map(const UtcDateTimeConverter())();
  DateTimeColumn get dateRequested => dateTime().nullable().map(const UtcDateTimeConverter())();

  // Entity fields
  DateTimeColumn get createdAtInRelay => dateTime().nullable().map(const UtcDateTimeConverter())();
  // sender, if current user receiver, and vice versa
  TextColumn get userPubkey => text().nullable()();
  // If asset is nft
  TextColumn get assetId => text().nullable()();
  // If asset is coin
  TextColumn get transferredAmount => text().nullable()();
  RealColumn get transferredAmountUsd => real().nullable()();
  TextColumn get balanceBeforeTransfer => text().nullable()();

  @override
  Set<Column> get primaryKey => {txHash};
}

/// We need to be sure that the data in the db is stored in a single format,
/// so a custom type converter was used for that purpose.
class UtcDateTimeConverter extends TypeConverter<DateTime?, DateTime?> {
  const UtcDateTimeConverter();

  @override
  DateTime? fromSql(DateTime? fromDb) => fromDb?.toUtc();

  @override
  DateTime? toSql(dynamic value) => value is DateTime ? value.toUtc() : null;
}
