// SPDX-License-Identifier: ice License 1.0

part of '../block_user_database.m.dart';

class UnblockEventTable extends Table {
  TextColumn get eventReference => text().map(const EventReferenceConverter())();

  @override
  Set<Column> get primaryKey => {eventReference};
}
