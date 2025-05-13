// SPDX-License-Identifier: ice License 1.0

part of '../chat_database.c.dart';

@DataClassName('EventMessageDbModel')
class EventMessageTable extends Table {
  late final id = text()();
  late final kind = integer()();
  late final pubkey = text()();
  late final masterPubkey = text()();
  late final createdAt = dateTime()();
  late final content = text()();
  late final tags = text().map(const EventTagsConverter())();
  late final eventReference = text().map(const EventReferenceConverter())();
  @override
  Set<Column> get primaryKey => {eventReference};
}
