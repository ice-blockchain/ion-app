// SPDX-License-Identifier: ice License 1.0

import 'package:drift/drift.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/wallet/data/coins/database/coins_database.c.dart';
import 'package:ion/app/features/wallet/data/coins/database/coins_table.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'coins_dao.c.g.dart';

@Riverpod(keepAlive: true)
CoinsDao coinsDao(Ref ref) => CoinsDao(db: ref.watch(coinsDatabaseProvider));

@DriftAccessor(tables: [CoinsTable])
class CoinsDao extends DatabaseAccessor<CoinsDatabase> with _$CoinsDaoMixin {
  CoinsDao({required CoinsDatabase db}) : super(db);

  Future<bool> hasAny() async {
    final query = select(coinsTable)..limit(1);
    final result = await query.get();
    return result.isNotEmpty;
  }

  Future<void> upsertAll(List<Coin> coins) async {
    await batch((batch) {
      batch.insertAllOnConflictUpdate(coinsTable, coins);
    });
  }

  Future<void> clear() async {
    await delete(coinsTable).go();
  }

  Stream<List<Coin>> watch(Iterable<String>? coinIds) {
    if (coinIds?.isEmpty ?? true) {
      return select(coinsTable).watch();
    }
    return (select(coinsTable)..where((row) => row.id.isIn(coinIds!))).watch();
  }

  Future<List<Coin>> get(Iterable<String>? coinIds) {
    if (coinIds?.isEmpty ?? true) {
      return select(coinsTable).get();
    }
    return (select(coinsTable)..where((row) => row.id.isIn(coinIds!))).get();
  }
}
