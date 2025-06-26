// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/features/wallets/model/transaction_details.f.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'transaction_provider.r.g.dart';

/// This notifier responsible for providing the transaction data to the UI.
/// Transaction details are provided after the transaction is sent
/// or from the transactions history.
@Riverpod(keepAlive: true)
class TransactionNotifier extends _$TransactionNotifier {
  @override
  TransactionDetails? build() {
    return null;
  }

  set details(TransactionDetails data) => state = data;
}
