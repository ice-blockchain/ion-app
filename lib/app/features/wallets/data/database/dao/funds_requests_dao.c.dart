// SPDX-License-Identifier: ice License 1.0

import 'package:drift/drift.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/wallets/data/database/wallets_database.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'funds_requests_dao.c.g.dart';

@Riverpod(keepAlive: true)
FundsRequestsDao fundsRequestsDao(Ref ref) => FundsRequestsDao(ref.watch(walletsDatabaseProvider));

class FundsRequestsDao {
  FundsRequestsDao(this._db);

  final WalletsDatabase _db;

  Future<DateTime?> getLastCreatedAt() async {
    final query = _db.select(_db.fundsRequestsTable)
      ..orderBy([(t) => OrderingTerm.desc(t.createdAt)])
      ..limit(1);

    final result = await query.getSingleOrNull();
    return result?.createdAt;
  }

  Future<FundsRequest?> getFundsRequestById(String eventId) =>
      (_db.select(_db.fundsRequestsTable)..where((t) => t.eventId.equals(eventId)))
          .getSingleOrNull();

  Future<int> saveFundsRequest(FundsRequest fundsRequest) =>
      _db.into(_db.fundsRequestsTable).insertOnConflictUpdate(fundsRequest);

  Future<int> saveFundsRequests(List<FundsRequest> fundsRequests) async {
    await _db.batch((batch) {
      batch.insertAllOnConflictUpdate(_db.fundsRequestsTable, fundsRequests);
    });
    return fundsRequests.length;
  }
}
