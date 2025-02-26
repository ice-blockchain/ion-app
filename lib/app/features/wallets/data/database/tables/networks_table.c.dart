// SPDX-License-Identifier: ice License 1.0

import 'package:drift/drift.dart';

@DataClassName('Network')
class NetworksTable extends Table {
  TextColumn get id => text()();
  TextColumn get image => text()();
  BoolColumn get isTestnet => boolean()();
  TextColumn get displayName => text()();
  TextColumn get explorerUrl => text()();

  @override
  Set<Column> get primaryKey => {id};
}
