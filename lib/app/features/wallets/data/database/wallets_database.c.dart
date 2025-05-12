// SPDX-License-Identifier: ice License 1.0

import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/wallets/data/database/tables/coins_table.c.dart';
import 'package:ion/app/features/wallets/data/database/tables/crypto_wallets_table.c.dart';
import 'package:ion/app/features/wallets/data/database/tables/duration_type.dart';
import 'package:ion/app/features/wallets/data/database/tables/funds_requests_table.c.dart';
import 'package:ion/app/features/wallets/data/database/tables/networks_table.c.dart';
import 'package:ion/app/features/wallets/data/database/tables/sync_coins_table.c.dart';
import 'package:ion/app/features/wallets/data/database/tables/transactions_table.c.dart';
import 'package:ion/app/features/wallets/data/database/wallets_database.c.steps.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'wallets_database.c.g.dart';

@Riverpod(keepAlive: true)
WalletsDatabase walletsDatabase(Ref ref) {
  final pubkey = ref.watch(currentPubkeySelectorProvider);

  if (pubkey == null) {
    throw UserMasterPubkeyNotFoundException();
  }

  final database = WalletsDatabase(pubkey);

  onLogout(ref, database.close);

  return database;
}

// DO NOT create or use database directly, use proxy notifier
// [IONDatabaseNotifier] methods instead
@DriftDatabase(
  tables: [
    CoinsTable,
    SyncCoinsTable,
    NetworksTable,
    TransactionsTable,
    TemporaryTransactionsTable,
    CryptoWalletsTable,
    FundsRequestsTable,
  ],
)
class WalletsDatabase extends _$WalletsDatabase {
  WalletsDatabase(this.pubkey) : super(_openConnection(pubkey));

  final String pubkey;

  @override
  int get schemaVersion => 7;

  static QueryExecutor _openConnection(String pubkey) {
    return driftDatabase(name: 'wallets_database_$pubkey');
  }

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (m) => m.createAll(),
      onUpgrade: stepByStep(
        from1To2: (m, schema) async {
          await m.createTable(schema.fundsRequestsTable);
        },
        from2To3: (m, schema) async {
          await m.addColumn(schema.networksTable, schema.networksTable.tier);
        },
        from3To4: (m, schema) async {
          await m.dropColumn(schema.transactionsTable, 'balance_before_transfer');
        },
        from4To5: (m, schema) async {
          await m.dropColumn(schema.fundsRequestsTable, 'is_pending');
          await m.addColumn(schema.fundsRequestsTable, schema.fundsRequestsTable.transactionId);
        },
        from5To6: (m, schema) async {
          await m.alterTable(
            TableMigration(transactionsTable),
          );
        },
        from6To7: (m, schema) async {
          await m.createTable(temporaryTransactionsTable);

          final tempTableName = temporaryTransactionsTable.actualTableName;
          final txTableName = transactionsTable.actualTableName;

          final tempCols = temporaryTransactionsTable.$columns;
          final oldCols = transactionsTable.$columns;

          final insertColumns = <String>[];
          final selectColumns = <String>[];

          for (final col in tempCols) {
            final name = col.$name;
            final existsInOld = oldCols.any((c) => c.$name == name);

            insertColumns.add(name);
            selectColumns.add(
              // Use an empty string for the walletViewId as a default.
              // It will be updated automatically by system in the future.
              existsInOld ? name : "'' AS walletViewId",
            );
          }

          final insertList = insertColumns.join(', ');
          final selectList = selectColumns.join(', ');

          // Copy date from the old table to the temp one
          await customStatement('''
INSERT INTO $tempTableName ($insertList)
SELECT $selectList
FROM $txTableName;
''');

          await m.deleteTable(txTableName);
          await customStatement('ALTER TABLE $tempTableName RENAME TO $txTableName');
        },
      ),
    );
  }
}
