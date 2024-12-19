// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/services/database/ion_database.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'coins_repository.c.g.dart';

@Riverpod(keepAlive: true)
CoinsRepository coinsRepository(Ref ref) => CoinsRepository(db: ref.watch(ionDatabaseProvider));

class CoinsRepository {
  CoinsRepository({
    required IONDatabase db,
  }) : _db = db;

  final IONDatabase _db;

  Future<List<Coin>> fetchAll() async {
    return _db.select(_db.coinsTable).get();
  }

  Future<void> save(Coin coin) async {
    await _db.into(_db.coinsTable).insert(coin);
  }

  Future<void> saveAll(List<Coin> coins) async {
    await _db.batch((batch) {
      batch.insertAll(_db.coinsTable, coins);
    });
  }

  Future<void> clear() async {
    await _db.delete(_db.coinsTable).go();
  }
}
