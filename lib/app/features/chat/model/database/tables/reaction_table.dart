// SPDX-License-Identifier: ice License 1.0

part of '../chat_database.c.dart';

class ReactionTable extends Table {
  late final id = integer().autoIncrement()();
  late final content = text()();
  late final masterPubkey = text()();
  late final isDeleted = boolean().withDefault(const Constant(false))();
  late final eventMessageId = text().references(EventMessageTable, #id)();
}
