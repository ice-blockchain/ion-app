// SPDX-License-Identifier: ice License 1.0

part of '../blocked_users_database.c.dart';

class DeletedBlockEventTable extends Table {
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();
  TextColumn get eventReference => text().map(const EventReferenceConverter())();

  @override
  Set<Column> get primaryKey => {eventReference};
}
