// SPDX-License-Identifier: ice License 1.0

import 'package:drift/drift.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/wallets/data/database/tables/coins_table.c.dart';
import 'package:ion/app/features/wallets/data/database/wallets_database.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'coins_dao.c.g.dart';

@Riverpod(keepAlive: true)
CoinsDao coinsDao(Ref ref) => CoinsDao(db: ref.watch(walletsDatabaseProvider));

@DriftAccessor(tables: [CoinsTable])
class CoinsDao extends DatabaseAccessor<WalletsDatabase> with _$CoinsDaoMixin {
  CoinsDao({required WalletsDatabase db}) : super(db);

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

  Future<List<Coin>> search(String query) {
    final formattedQuery = '%${query.trim().toLowerCase()}%';

    return (select(coinsTable)
          ..where(
            (row) =>
                row.symbol.lower().like(formattedQuery) | row.name.lower().like(formattedQuery),
          ))
        .get();
  }

  Future<List<Coin>> getByFilters({
    String? symbolGroup,
    String? symbol,
    String? network,
    String? contractAddress,
  }) {
    final query = select(coinsTable);
    if (symbolGroup != null) {
      query.where((row) => row.symbolGroup.lower().equals(symbolGroup.toLowerCase()));
    }
    if (symbol != null) {
      query.where((row) => row.symbol.lower().equals(symbol.toLowerCase()));
    }
    if (network != null) {
      query.where((row) => row.network.lower().equals(network.toLowerCase()));
    }
    if (contractAddress != null) {
      query.where((row) => row.contractAddress.equals(contractAddress));
    }
    return query.get();
  }
}
