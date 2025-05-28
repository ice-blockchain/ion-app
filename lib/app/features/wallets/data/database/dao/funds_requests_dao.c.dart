// SPDX-License-Identifier: ice License 1.0

import 'package:drift/drift.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/database.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/wallets/data/database/tables/funds_requests_table.c.dart';
import 'package:ion/app/features/wallets/data/database/tables/transactions_table.c.dart';
import 'package:ion/app/features/wallets/data/database/wallets_database.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'funds_requests_dao.c.g.dart';

@Riverpod(keepAlive: true)
FundsRequestsDao fundsRequestsDao(Ref ref) => FundsRequestsDao(
      db: ref.watch(walletsDatabaseProvider),
    );

@DriftAccessor(tables: [FundsRequestsTable, TransactionsTable])
class FundsRequestsDao extends DatabaseAccessor<WalletsDatabase> with _$FundsRequestsDaoMixin {
  FundsRequestsDao({required WalletsDatabase db}) : super(db);

  Future<DateTime?> getLastCreatedAt() async {
    final max = await maxTimestamp(
      fundsRequestsTable,
      fundsRequestsTable.actualTableName,
      fundsRequestsTable.createdAt.name,
    );
    return max?.toDateTime;
  }

  Future<DateTime?> getFirstCreatedAt({DateTime? after}) async {
    final min = await minTimestamp(
      fundsRequestsTable,
      fundsRequestsTable.actualTableName,
      fundsRequestsTable.createdAt.name,
      after: after?.microsecondsSinceEpoch,
    );
    return min?.toDateTime;
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
}
