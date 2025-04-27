// SPDX-License-Identifier: ice License 1.0

part of '../chat_database.c.dart';

class ReactionTable extends Table {
  @ReferenceName('reactionEventRef')
  late final id = text().references(EventMessageTable, #id)();

  @ReferenceName('reactionSourceMessageRef')
  late final kind14SharedId = text()();

  late final content = text()();
  late final masterPubkey = text()();
  late final isDeleted = boolean().withDefault(const Constant(false))();
}
