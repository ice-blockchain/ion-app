// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/wallets/data/database/dao/transactions_visibility_status_dao.m.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'unseen_transactions_count_provider.r.g.dart';

@riverpod
Stream<int> getAllUnseenTransactionsCount(Ref ref) async* {
  yield* ref.watch(transactionsVisibilityStatusDaoProvider).getAllUnseenTransactionsCount();
}

@riverpod
Stream<bool> hasUnseenTransactions(Ref ref, List<String> coinIds) async* {
  yield* ref.watch(transactionsVisibilityStatusDaoProvider).hasUnseenTransactions(coinIds);
}
