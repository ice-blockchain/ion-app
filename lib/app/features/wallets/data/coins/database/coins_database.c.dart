// SPDX-License-Identifier: ice License 1.0

import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/wallets/data/coins/database/coins_table.c.dart';
import 'package:ion/app/features/wallets/data/coins/database/duration_type.dart';
import 'package:ion/app/features/wallets/data/coins/database/sync_coins_table.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'coins_database.c.g.dart';

@Riverpod(keepAlive: true)
CoinsDatabase coinsDatabase(Ref ref) => CoinsDatabase();

// DO NOT create or use database directly, use proxy notifier
// [IONDatabaseNotifier] methods instead
@DriftDatabase(
  tables: [
    CoinsTable,
    SyncCoinsTable,
  ],
)
class CoinsDatabase extends _$CoinsDatabase {
  CoinsDatabase() : super(_openConnection());

  // For testing executor
  CoinsDatabase.test(super.e);

  @override
  int get schemaVersion => 2;

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'coins_database');
  }

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (migration) => migration.createAll(),
        onUpgrade: (migration, from, to) async {
          if (from <= 1) {
            await migration.createTable(syncCoinsTable);
          }
        },
      );
}
