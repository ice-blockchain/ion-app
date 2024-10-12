// SPDX-License-Identifier: ice License 1.0

import 'package:ion_identity_client/ion_client.dart';

sealed class WalletsException extends IonException {
  const WalletsException([super.message]);
}

class WalletNotFoundException extends WalletsException {
  const WalletNotFoundException() : super('Wallet not found');
}
