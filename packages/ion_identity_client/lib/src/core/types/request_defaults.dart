// SPDX-License-Identifier: ice License 1.0

import 'package:ion_identity_client/src/auth/dtos/register_complete_wallet.dart';

class RequestDefaults {
  // TODO: replace with ION later
  static const registerCompleteWalletNetwork = 'Ton';
  static const registerCompleteWalletName = 'main';
  static const registerCompleteWallets = [
    RegisterCompleteWallet(
      network: registerCompleteWalletNetwork,
      name: registerCompleteWalletName,
    ),
  ];
}
