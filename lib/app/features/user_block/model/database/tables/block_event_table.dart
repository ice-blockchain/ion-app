// SPDX-License-Identifier: ice License 1.0

part of '../blocked_users_database.c.dart';

@DataClassName('BlockEventDbModel')
class BlockEventTable extends Table {
  TextColumn get id => text()();
  TextColumn get sharedId => text()();
  TextColumn get content => text()();
  IntColumn get kind => integer()();
  TextColumn get pubkey => text()();
  TextColumn get masterPubkey => text()();
  IntColumn get createdAt => integer()();
  TextColumn get tags => text().map(const EventTagsConverter())();
  TextColumn get eventReference => text().map(const EventReferenceConverter())();

  @override
  Set<Column> get primaryKey => {eventReference};
}
