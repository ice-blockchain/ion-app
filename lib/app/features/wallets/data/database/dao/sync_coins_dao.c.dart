// SPDX-License-Identifier: ice License 1.0

import 'package:drift/drift.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/wallets/data/database/tables/coins_table.c.dart';
import 'package:ion/app/features/wallets/data/database/tables/sync_coins_table.c.dart';
import 'package:ion/app/features/wallets/data/database/wallets_database.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sync_coins_dao.c.g.dart';

@Riverpod(keepAlive: true)
SyncCoinsDao syncCoinsDao(Ref ref) => SyncCoinsDao(db: ref.watch(walletsDatabaseProvider));

@DriftAccessor(tables: [CoinsTable, SyncCoinsTable])
class SyncCoinsDao extends DatabaseAccessor<WalletsDatabase> with _$SyncCoinsDaoMixin {
  SyncCoinsDao({
    required WalletsDatabase db,
  }) : super(db);

  Future<void> insertAll(List<SyncCoins> syncCoinsCompanions) async {
    await batch((batch) {
      batch.insertAllOnConflictUpdate(syncCoinsTable, syncCoinsCompanions);
    });
  }

  Future<DateTime?> getNextSyncTime() async {
    return (select(syncCoinsTable)
          ..orderBy([(tbl) => OrderingTerm.asc(tbl.syncAfter)])
          ..limit(1))
        .getSingleOrNull()
        .then((row) => row?.syncAfter);
  }

  Future<bool> hasAny() async {
    final query = select(syncCoinsTable)..limit(1);
    final result = await query.get();
    return result.isNotEmpty;
  }

  /// Returns a list of coins whose data expires after the specified date.
  Future<List<Coin>> getCoinsToSync(DateTime expirationDate) async {
    final query = select(syncCoinsTable)
        .join([innerJoin(coinsTable, coinsTable.id.equalsExp(syncCoinsTable.coinId))])
      ..where(syncCoinsTable.syncAfter.isSmallerThanValue(expirationDate));
    return query.map((row) => row.readTable(coinsTable)).get();
  }

  Future<void> clear() async {
    await delete(syncCoinsTable).go();
  }
}
