// SPDX-License-Identifier: ice License 1.0

import 'package:ion_identity_client/ion_identity.dart';

sealed class WalletsException extends IONIdentityException {
  const WalletsException([super.message]);
}

class WalletNotFoundException extends WalletsException {
  const WalletNotFoundException() : super('Wallet not found');
}
