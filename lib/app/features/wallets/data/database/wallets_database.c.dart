// SPDX-License-Identifier: ice License 1.0

import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/wallets/data/database/tables/coins_table.c.dart';
import 'package:ion/app/features/wallets/data/database/tables/duration_type.dart';
import 'package:ion/app/features/wallets/data/database/tables/networks_table.c.dart';
import 'package:ion/app/features/wallets/data/database/tables/sync_coins_table.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'wallets_database.c.g.dart';

@Riverpod(keepAlive: true)
WalletsDatabase walletsDatabase(Ref ref) => WalletsDatabase();

// DO NOT create or use database directly, use proxy notifier
// [IONDatabaseNotifier] methods instead
@DriftDatabase(
  tables: [
    CoinsTable,
    SyncCoinsTable,
    NetworksTable,
  ],
)
class WalletsDatabase extends _$WalletsDatabase {
  WalletsDatabase() : super(_openConnection());

  // For testing executor
  WalletsDatabase.test(super.e);

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'wallets_database');
  }
}
