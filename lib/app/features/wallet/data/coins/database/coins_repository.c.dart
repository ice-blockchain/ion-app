// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/wallet/data/coins/database/coins_database.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'coins_repository.c.g.dart';

@Riverpod(keepAlive: true)
CoinsRepository coinsRepository(Ref ref) => CoinsRepository(db: ref.watch(coinsDatabaseProvider));

class CoinsRepository {
  CoinsRepository({
    required CoinsDatabase db,
  }) : _db = db;

  final CoinsDatabase _db;

  Future<bool> hasAny() async {
    final query = _db.select(_db.coinsTable)..limit(1);
    final result = await query.get();
    return result.isNotEmpty;
  }

  Future<void> upsertAll(List<Coin> coins) async {
    await _db.batch((batch) {
      batch.insertAllOnConflictUpdate(_db.coinsTable, coins);
    });
  }

  Future<void> clear() async {
    await _db.delete(_db.coinsTable).go();
  }
}
