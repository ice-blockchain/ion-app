// SPDX-License-Identifier: ice License 1.0

import 'package:drift/drift.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/wallets/data/database/tables/coins_table.c.dart';
import 'package:ion/app/features/wallets/data/database/tables/networks_table.c.dart';
import 'package:ion/app/features/wallets/data/database/wallets_database.c.dart';
import 'package:ion/app/features/wallets/model/coin_data.c.dart';
import 'package:ion/app/features/wallets/model/coins_group.c.dart';
import 'package:ion/app/features/wallets/model/network_data.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'coins_dao.c.g.dart';

@Riverpod(keepAlive: true)
CoinsDao coinsDao(Ref ref) => CoinsDao(db: ref.watch(walletsDatabaseProvider));

@DriftAccessor(tables: [CoinsTable, NetworksTable])
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

  Stream<List<CoinData>> watch(Iterable<String>? coinIds) {
    final query = select(coinsTable).join([
      leftOuterJoin(networksTable, networksTable.id.equalsExp(coinsTable.networkId)),
    ]);

    if (coinIds?.isNotEmpty ?? false) {
      query.where(coinsTable.id.isIn(coinIds!));
    }

    return query.map(_toCoinData).watch();
  }

  Future<CoinData?> getById(String coinId) {
    final query = select(coinsTable).join([
      leftOuterJoin(networksTable, networksTable.id.equalsExp(coinsTable.networkId)),
    ])
      ..where(coinsTable.id.equals(coinId));

    return query.map(_toCoinData).getSingleOrNull();
  }

  Future<List<CoinData>> get(Iterable<String>? coinIds) {
    final query = select(coinsTable).join([
      leftOuterJoin(networksTable, networksTable.id.equalsExp(coinsTable.networkId)),
    ]);

    if (coinIds?.isNotEmpty ?? false) {
      query.where(coinsTable.id.isIn(coinIds!));
    }

    return query.map(_toCoinData).get();
  }

  Future<List<CoinData>> search(String searchQuery) {
    final formattedQuery = '%${searchQuery.trim().toLowerCase()}%';
    final exactMatchQuery = searchQuery.trim().toLowerCase();

    final query = select(coinsTable).join([
      leftOuterJoin(networksTable, networksTable.id.equalsExp(coinsTable.networkId)),
    ])
      ..where(
        coinsTable.symbol.lower().like(formattedQuery) |
            coinsTable.name.lower().like(formattedQuery),
      )
      ..orderBy([
        // 1. Coins with exact symbol
        OrderingTerm(
          expression: coinsTable.symbol.lower().equals(exactMatchQuery),
          mode: OrderingMode.desc,
        ),
        // 2. Coins with exact names
        OrderingTerm(
          expression: coinsTable.name.lower().equals(exactMatchQuery),
          mode: OrderingMode.desc,
        ),
        // 3. Coins where the symbol starts with the entered query
        OrderingTerm(
          expression: coinsTable.symbol.lower().like('$exactMatchQuery%'),
          mode: OrderingMode.desc,
        ),
        // 4. Coins where the name starts with the entered query
        OrderingTerm(
          expression: coinsTable.name.lower().like('$exactMatchQuery%'),
          mode: OrderingMode.desc,
        ),
      ]);

    return query.map(_toCoinData).get();
  }

  Future<CoinData?> getNativeCoin(String networkId) async {
    final result = await getByFilters(isNative: true, networks: [networkId]);
    return result.firstOrNull;
  }

  Future<List<CoinData>> getByFilters({
    Iterable<String>? symbolGroups,
    Iterable<String>? symbols,
    Iterable<String>? networks,
    Iterable<String>? contractAddresses,
    bool? isNative,
  }) {
    final query = select(coinsTable).join([
      leftOuterJoin(networksTable, networksTable.id.equalsExp(coinsTable.networkId)),
    ]);

    if (symbolGroups?.isNotEmpty ?? false) {
      query.where(coinsTable.symbolGroup.isIn(symbolGroups!));
    }

    if (symbols?.isNotEmpty ?? false) {
      final lowered = symbols!.map((e) => e.toLowerCase()).toList();
      query.where(coinsTable.symbol.lower().isIn(lowered));
    }

    if (networks?.isNotEmpty ?? false) {
      query.where(networksTable.id.isIn(networks!));
    }

    if (contractAddresses?.isNotEmpty ?? false) {
      query.where(coinsTable.contractAddress.isIn(contractAddresses!));
    }

    if (isNative != null) {
      query.where(coinsTable.native.equals(isNative));
    }

    return query.map(_toCoinData).get();
  }

  CoinData _toCoinData(TypedResult row) {
    return CoinData.fromDB(
      row.readTable(coinsTable),
      NetworkData.fromDB(
        row.readTable(networksTable),
      ),
    );
  }

  Future<Iterable<CoinsGroup>> getCoinGroups({
    int? limit,
    int? offset,
    Iterable<String>? excludeCoinIds,
  }) {}
}
