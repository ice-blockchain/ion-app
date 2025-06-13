// SPDX-License-Identifier: ice License 1.0

import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/extensions/database.dart';
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

@riverpod
WalletsDatabase walletsDatabase(Ref ref) {
  keepAliveWhenAuthenticated(ref);

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
    CryptoWalletsTable,
    FundsRequestsTable,
  ],
)
class WalletsDatabase extends _$WalletsDatabase {
  WalletsDatabase(this.pubkey) : super(_openConnection(pubkey));

  final String pubkey;

  @override
  int get schemaVersion => 13;

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
          const oldTransactionsTableName = 'transactions_table';
          await m.createTable(transactionsTable);

          await customStatement('''
          INSERT INTO ${transactionsTable.actualTableName} (
            wallet_view_id, 
            type, tx_hash, network_id, coin_id, sender_wallet_address, 
            receiver_wallet_address, id, fee, status, native_coin_id, 
            date_confirmed, date_requested, created_at_in_relay, user_pubkey, 
            asset_id, transferred_amount, transferred_amount_usd
          )
          SELECT 
            '', 
            type, tx_hash, network_id, coin_id, sender_wallet_address, 
            receiver_wallet_address, id, fee, status, native_coin_id, 
            date_confirmed, date_requested, created_at_in_relay, user_pubkey, 
            asset_id, transferred_amount, transferred_amount_usd
          FROM $oldTransactionsTableName;
          ''');

          await m.deleteTable(oldTransactionsTableName);
        },
        from7To8: (m, schema) async {
          final columnExists = await isColumnExists(
            tableName: schema.transactionsTableV2.actualTableName,
            columnName: 'event_id',
          );
          if (!columnExists) {
            await m.addColumn(schema.transactionsTableV2, schema.transactionsTableV2.eventId);
          }
        },
        from8To9: (Migrator m, Schema9 schema) async {
          await m.alterTable(
            TableMigration(
              schema.coinsTable,
              columnTransformer: {
                schema.coinsTable.native: const Constant(false),
              },
              newColumns: [schema.coinsTable.native],
            ),
          );
        },
        from9To10: (Migrator m, Schema10 schema) async {
          final columnExists = await isColumnExists(
            tableName: schema.coinsTable.actualTableName,
            columnName: 'prioritized',
          );
          if (!columnExists) {
            await m.addColumn(schema.coinsTable, schema.coinsTable.prioritized);
          }
        },
        from10To11: (m, schema) async {
          await m.alterTable(
            TableMigration(
              schema.coinsTable,
              columnTransformer: {
                schema.coinsTable.native: const Constant(false),
                schema.coinsTable.prioritized: const Constant(false),
              },
            ),
          );
        },
        from11To12: (m, schema) async {
          final isExternalHashColumnExists = await isColumnExists(
            tableName: schema.transactionsTableV2.actualTableName,
            columnName: 'external_hash',
          );
          if (!isExternalHashColumnExists) {
            await m.addColumn(schema.transactionsTableV2, schema.transactionsTableV2.externalHash);
          }
        },
        from12To13: (m, schema) async {
          final table = schema.fundsRequestsTable;
          await m.alterTable(
            TableMigration(
              table,
              columnTransformer: {
                table.createdAt: table.normalizedTimestamp(table.createdAt),
              },
            ),
          );
        },
      ),
    );
  }

  Future<bool> isColumnExists({required String tableName, required String columnName}) async {
    final rows = await customSelect('PRAGMA table_info($tableName)').get();
    return rows.any((row) => row.data['name'] == columnName);
  }
}
