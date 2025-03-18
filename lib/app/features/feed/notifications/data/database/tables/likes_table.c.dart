// SPDX-License-Identifier: ice License 1.0

import 'package:drift/drift.dart';

@DataClassName('Like')
class LikesTable extends Table {
  TextColumn get eventId => text()();
  TextColumn get pubkey => text()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {eventId, pubkey};
}
