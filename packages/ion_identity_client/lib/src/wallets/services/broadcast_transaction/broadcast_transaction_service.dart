// SPDX-License-Identifier: ice License 1.0

import 'package:ion_identity_client/ion_identity.dart';
import 'package:ion_identity_client/src/core/types/http_method.dart';
import 'package:ion_identity_client/src/signer/types/user_action_signing_request.dart';
import 'package:ion_identity_client/src/signer/user_action_signer.dart';
import 'package:ion_identity_client/src/wallets/services/broadcast_transaction/domain/transaction_creator/transaction_creator_factory.dart';
import 'package:ion_identity_client/src/wallets/services/broadcast_transaction/models/transaction_request.dart';
import 'package:sprintf/sprintf.dart';

class BroadcastTransactionService {
  const BroadcastTransactionService(
    this.username,
    this._userActionSigner,
    this._factory,
  );

  final String username;
  final UserActionSigner _userActionSigner;
  final TransactionCreatorFactory _factory;

  // [walletId]
  static const _transactionsPath = '/wallets/%s/transactions';

  Future<Map<String, dynamic>> broadcastTransaction(TransactionRequest transactionRequest) async {
    final creator = _factory.getCreator(transactionRequest.wallet.network);
    final transaction = await creator.createTransaction(transactionRequest);
    return _makeRequest(transactionRequest.wallet, transaction);
  }

  Future<Map<String, dynamic>> _makeRequest(
    Wallet wallet,
    Map<String, dynamic> transaction,
  ) async {
    final request = UserActionSigningRequest(
      username: username,
      method: HttpMethod.post,
      path: sprintf(_transactionsPath, [wallet.id]),
      body: transaction,
    );

    final response = await _userActionSigner.signWithPasskey(
      request,
      (json) => json,
    );

    return response;
  }
}
