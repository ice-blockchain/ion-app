// SPDX-License-Identifier: ice License 1.0

part of '../chat_database.c.dart';

class ReactionTable extends Table {
  late final eventReferenceId =
      text().map(const EventReferenceConverter()).references(EventMessageTable, #eventReference)();
  TextColumn get kind14SharedId => text()();
  late final content = text()();
  late final masterPubkey = text()();
  late final isDeleted = boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {eventReferenceId};
}
