// SPDX-License-Identifier: ice License 1.0

part of '../chat_database.c.dart';

@DataClassName('EventMessageDbModel')
class EventMessageTable extends Table {
  TextColumn get id => text()();
  IntColumn get kind => integer()();
  TextColumn get pubkey => text()();
  TextColumn get masterPubkey => text()();
  DateTimeColumn get createdAt => dateTime()();
  TextColumn get content => text()();
  TextColumn get tags => text().map(const EventTagsConverter())();
  TextColumn get eventReference => text().map(const EventReferenceConverter())();

  @override
  Set<Column> get primaryKey => {eventReference};
}
