// SPDX-License-Identifier: ice License 1.0

import 'package:ion_identity_client/src/wallets/services/broadcast_transaction/models/transaction_request.dart';

abstract class TransactionCreator {
  Future<Map<String, dynamic>> createTransaction(TransactionRequest request);
}
