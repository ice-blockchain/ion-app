// SPDX-License-Identifier: ice License 1.0

import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/wallets/data/networks/database/networks_table.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'networks_database.c.g.dart';

@Riverpod(keepAlive: true)
NetworksDatabase networksDatabase(Ref ref) => NetworksDatabase();

// DO NOT create or use database directly, use proxy notifier
// [IONDatabaseNotifier] methods instead
@DriftDatabase(
  tables: [
    NetworksTable,
  ],
)
class NetworksDatabase extends _$NetworksDatabase {
  NetworksDatabase() : super(_openConnection());

  // For testing executor
  NetworksDatabase.test(super.e);

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'networks_database');
  }
}
