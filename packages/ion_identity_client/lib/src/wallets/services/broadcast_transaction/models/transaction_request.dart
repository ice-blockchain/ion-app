// SPDX-License-Identifier: ice License 1.0

import 'package:ion_identity_client/ion_identity.dart';

class TransactionRequest {
  TransactionRequest(this.wallet, this.destinationAddress, this.amount);
  final Wallet wallet;
  final String destinationAddress;
  final String amount;
}
