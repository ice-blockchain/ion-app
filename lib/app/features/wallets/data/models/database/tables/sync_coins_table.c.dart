// SPDX-License-Identifier: ice License 1.0

import 'package:drift/drift.dart';

@DataClassName('SyncCoins')
class SyncCoinsTable extends Table {
  TextColumn get coinId => text()();
  DateTimeColumn get syncAfter => dateTime()();

  @override
  Set<Column> get primaryKey => {coinId};
}
