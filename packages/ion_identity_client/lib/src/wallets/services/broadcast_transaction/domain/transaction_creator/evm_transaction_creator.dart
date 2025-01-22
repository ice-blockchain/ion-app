// SPDX-License-Identifier: ice License 1.0

import 'package:ion_identity_client/src/wallets/services/broadcast_transaction/domain/transaction_creator/transaction_creator.dart';
import 'package:ion_identity_client/src/wallets/services/broadcast_transaction/models/transaction_request.dart';

class EvmTransactionCreator implements TransactionCreator {
  @override
  Future<Map<String, dynamic>> createTransaction(TransactionRequest request) async {
    return {
      'kind': 'Evm',
      'to': request.destinationAddress,
      'value': request.amount,
    };
  }
}
