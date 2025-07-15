// SPDX-License-Identifier: ice License 1.0

import 'package:drift/drift.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/wallets/data/database/tables/funds_requests_table.d.dart';
import 'package:ion/app/features/wallets/data/database/tables/transactions_table.d.dart';
import 'package:ion/app/features/wallets/data/database/wallets_database.m.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'funds_requests_dao.m.g.dart';

@Riverpod(keepAlive: true)
FundsRequestsDao fundsRequestsDao(Ref ref) => FundsRequestsDao(
      db: ref.watch(walletsDatabaseProvider),
    );

@DriftAccessor(tables: [FundsRequestsTable, TransactionsTable])
class FundsRequestsDao extends DatabaseAccessor<WalletsDatabase> with _$FundsRequestsDaoMixin {
  FundsRequestsDao({required WalletsDatabase db}) : super(db);

  Future<DateTime?> getLastCreatedAt() async {
    final query = select(fundsRequestsTable)
      ..orderBy([(t) => OrderingTerm.desc(t.createdAt)])
      ..limit(1);

    final result = await query.getSingleOrNull();
    return result?.createdAt.toDateTime;
  }

  Future<DateTime?> getFirstCreatedAt({DateTime? after}) async {
    final query = select(fundsRequestsTable);
    if (after != null) {
      query.where(
        (t) => t.createdAt.isBiggerThanValue(after.microsecondsSinceEpoch),
      );
    }
    query
      ..orderBy([(t) => OrderingTerm.asc(t.createdAt)])
      ..limit(1);

    final result = await query.getSingleOrNull();
    return result?.createdAt.toDateTime;
  }

  Stream<FundsRequest?> watchFundsRequestById(String eventId) =>
      (select(fundsRequestsTable)..where((t) => t.eventId.equals(eventId))).watchSingleOrNull();

  Future<int> saveFundsRequest(FundsRequest fundsRequest) => into(fundsRequestsTable).insert(
        fundsRequest,
        mode: InsertMode.insertOrIgnore,
      );

  Future<int> saveFundsRequests(List<FundsRequest> fundsRequests) async {
    await batch((batch) {
      batch.insertAllOnConflictUpdate(fundsRequestsTable, fundsRequests);
    });
    return fundsRequests.length;
  }

  Future<bool> markRequestAsPaid(String eventId, String transactionId) async {
    final query = update(fundsRequestsTable)..where((t) => t.eventId.equals(eventId));

    final rowsAffected = await query.write(
      FundsRequestsTableCompanion(
        transactionId: Value(transactionId),
      ),
    );

    return rowsAffected > 0;
  }

  Future<bool> markRequestAsDeleted(String eventId) async {
    final query = update(fundsRequestsTable)..where((t) => t.eventId.equals(eventId));

    final rowsAffected = await query.write(
      const FundsRequestsTableCompanion(
        deleted: Value(true),
      ),
    );

    return rowsAffected > 0;
  }
}
