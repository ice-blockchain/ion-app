// SPDX-License-Identifier: ice License 1.0

import 'package:drift/drift.dart';
import 'package:ion/app/features/wallets/data/database/dao/transactions_visibility_status_dao.m.dart';

@DataClassName('TransactionsVisibilityStatus')
class TransactionVisibilityStatusTable extends Table {
  TextColumn get txHash => text()();
  TextColumn get walletViewId => text()();
  IntColumn get status => intEnum<TransactionVisibilityStatus>()();

  @override
  Set<Column> get primaryKey => {txHash, walletViewId};
}
