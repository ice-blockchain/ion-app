// SPDX-License-Identifier: ice License 1.0

import 'package:drift/drift.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/wallets/data/networks/database/networks_database.c.dart';
import 'package:ion/app/features/wallets/data/networks/database/networks_table.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'networks_dao.c.g.dart';

@Riverpod(keepAlive: true)
NetworksDao networksDao(Ref ref) => NetworksDao(db: ref.watch(networksDatabaseProvider));

@DriftAccessor(tables: [NetworksTable])
class NetworksDao extends DatabaseAccessor<NetworksDatabase> with _$NetworksDaoMixin {
  NetworksDao({required NetworksDatabase db}) : super(db);

  Future<void> insertAll(List<Network> networks) async {
    await batch((batch) {
      batch.insertAllOnConflictUpdate(networksTable, networks);
    });
  }

  Future<List<Network>> getAll() {
    return select(networksTable).get();
  }

  Stream<List<Network>> watchNetworks() {
    return select(networksTable).watch();
  }

  Future<Network?> getById(String id) {
    final query = select(networksTable)
      ..where((t) => t.id.equals(id))
      ..limit(1);
    return query.getSingleOrNull();
  }

  Future<bool> hasAny() async {
    final query = select(networksTable)..limit(1);
    final result = await query.get();
    return result.isNotEmpty;
  }
}
