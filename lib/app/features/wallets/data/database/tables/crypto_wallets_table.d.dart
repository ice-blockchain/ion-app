// SPDX-License-Identifier: ice License 1.0

import 'package:drift/drift.dart';

@DataClassName('CryptoWallet')
class CryptoWalletsTable extends Table {
  TextColumn get id => text()();
  TextColumn get address => text()();
  TextColumn get networkId => text()();
  BoolColumn get isHistoryLoaded => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}
