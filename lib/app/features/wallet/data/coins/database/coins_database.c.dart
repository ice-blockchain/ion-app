// SPDX-License-Identifier: ice License 1.0

import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/wallet/data/coins/database/coins_table.c.dart';
import 'package:ion/app/features/wallet/data/coins/database/duration_type.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'coins_database.c.g.dart';

@Riverpod(keepAlive: true)
CoinsDatabase coinsDatabase(Ref ref) => CoinsDatabase();

// DO NOT create or use database directly, use proxy notifier
// [IONDatabaseNotifier] methods instead
@DriftDatabase(
  tables: [
    CoinsTable,
  ],
)
class CoinsDatabase extends _$CoinsDatabase {
  CoinsDatabase() : super(_openConnection());

  // For testing executor
  CoinsDatabase.test(super.e);

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'coins_database');
  }
}
