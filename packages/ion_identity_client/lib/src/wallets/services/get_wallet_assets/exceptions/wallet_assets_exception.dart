// SPDX-License-Identifier: ice License 1.0

import 'package:ion_identity_client/src/core/types/ion_exception.dart';

sealed class WalletAssetsException extends IonException {
  const WalletAssetsException([super.message]);
}

class WalletNotFoundException extends WalletAssetsException {
  const WalletNotFoundException() : super('Wallet not found');
}

class UnknownWalletAssetsException extends WalletAssetsException {
  const UnknownWalletAssetsException() : super('Unknown error');
}
