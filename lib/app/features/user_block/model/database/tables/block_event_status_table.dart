// SPDX-License-Identifier: ice License 1.0

part of '../blocked_users_database.c.dart';

class BlockEventStatusTable extends Table {
  TextColumn get sharedId => text()();
  TextColumn get receiverPubkey => text()();
  TextColumn get receiverMasterPubkey => text()();
  IntColumn get status => intEnum<BlockedUserStatus>()();
  TextColumn get eventReference => text().map(const EventReferenceConverter())();

  @override
  Set<Column> get primaryKey => {eventReference};
}
