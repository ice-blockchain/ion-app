// SPDX-License-Identifier: ice License 1.0

import 'package:ion_identity_client/ion_identity.dart';
import 'package:ion_identity_client/src/core/types/http_method.dart';
import 'package:ion_identity_client/src/signer/types/user_action_signing_request.dart';
import 'package:sprintf/sprintf.dart';

class MakeTransferDataSource {
  const MakeTransferDataSource(this.username);

  final String username;

  /// [walletId]
  static const makeTransferPath = '/wallets/%s/transfers';

  UserActionSigningRequest buildTransferSigningRequest({
    required Wallet wallet,
    required Transfer transfer,
  }) {
    return UserActionSigningRequest(
      username: username,
      method: HttpMethod.post,
      path: sprintf(makeTransferPath, [wallet.id]),
      body: transfer.toJson(),
    );
  }
}
